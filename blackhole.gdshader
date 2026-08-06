shader_type spatial;
render_mode unshaded, cull_disabled;

// Screen and depth textures for gravitational lensing
uniform sampler2D screen_tex : hint_screen_texture, repeat_disable;
uniform sampler2D depth_tex : hint_depth_texture;

// Black hole parameters
uniform float black_hole_radius : hint_range(0.01, 10.0) = 0.15;
uniform float lensing_strength : hint_range(0.0, 2.0) = 1.0;
uniform float event_horizon_falloff : hint_range(0.0, 2.0) = 0.5;

// Accretion disc parameters
uniform bool enable_disc = true;
uniform float disc_inner_radius : hint_range(0.1, 5.0) = 0.3;
uniform float disc_outer_radius : hint_range(0.1, 20.0) = 4.0;
uniform float disc_rotation_speed : hint_range(-5.0, 5.0) = 0.5;
uniform vec3 disc_up_vector = vec3(0.0, 1.0, 0.0);

// Disc colors (temperature gradient)
uniform vec3 disc_color_inner : source_color = vec3(1.0, 1.0, 0.7);  // Hot/white-yellow
uniform vec3 disc_color_outer : source_color = vec3(1.0, 0.2, 0.02); // Cool/red-orange
uniform float disc_brightness : hint_range(0.0, 10.0) = 2.0;

// Noise for disc turbulence
uniform sampler2D noise_tex : hint_default_black;
uniform float turbulence_strength : hint_range(0.0, 1.0) = 0.3;

// Doppler beaming (relativistic effects)
uniform float doppler_factor : hint_range(0.0, 2.0) = 1.0;

// Gravity parameters for raymarching
uniform int max_steps : hint_range(8, 128) = 64;
uniform float step_size : hint_range(0.001, 0.1) = 0.02;

varying vec3 world_vertex;

void vertex() {
	world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

// Convert UV + depth to world position
vec3 get_world_position_from_uv(vec2 uv, float depth, mat4 inv_projection, mat4 inv_view) {
	vec4 clip = vec4(uv * 2.0 - 1.0, depth, 1.0);
	vec4 view = inv_projection * clip;
	view.xyz /= view.w;
	vec4 world = inv_view * vec4(view.xyz, 1.0);
	return world.xyz / world.w;
}

// Hash function for pseudo-random values
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Value noise for turbulence
float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal Brownian Motion for turbulent disc
float fbm(vec2 p, int octaves) {
	float value = 0.0;
	float amplitude = 0.5;
	float frequency = 1.0;
	
	for (int i = 0; i < octaves; i++) {
		value += amplitude * noise(p * frequency);
		amplitude *= 0.5;
		frequency *= 2.0;
	}
	
	return value;
}

// Ray-sphere intersection (entry and exit distances)
vec2 intersect_sphere(vec3 ray_origin, vec3 ray_dir, vec3 sphere_center, float radius) {
	vec3 offset = ray_origin - sphere_center;
	float a = dot(ray_dir, ray_dir);
	float b = 2.0 * dot(offset, ray_dir);
	float c = dot(offset, offset) - radius * radius;
	float discriminant = b * b - 4.0 * a * c;
	
	if (discriminant < 0.0) {
		return vec2(-1.0); // No intersection
	}
	
	float t1 = (-b - sqrt(discriminant)) / (2.0 * a);
	float t2 = (-b + sqrt(discriminant)) / (2.0 * a);
	return vec2(t1, t2);
}

// Rotate vector around axis by angle
vec3 rotate_around_axis(vec3 v, vec3 axis, float angle) {
	float c = cos(angle);
	float s = sin(angle);
	float t = 1.0 - c;
	
	axis = normalize(axis);
	return vec3(
		v.x * (t * axis.x * axis.x + c) + v.y * (t * axis.x * axis.y - s * axis.z) + v.z * (t * axis.x * axis.z + s * axis.y),
		v.x * (t * axis.x * axis.y + s * axis.z) + v.y * (t * axis.y * axis.y + c) + v.z * (t * axis.y * axis.z - s * axis.x),
		v.x * (t * axis.x * axis.z - s * axis.y) + v.y * (t * axis.y * axis.z + s * axis.x) + v.z * (t * axis.z * axis.z + c)
	);
}

// Signed distance to plane (for disc intersection)
float sd_plane(vec3 p, vec3 n, float h) {
	return dot(p, n) + h;
}

void fragment() {
	// Get world position of the fragment from depth
	float depth = texture(depth_tex, SCREEN_UV).x;
	vec3 world_pos = get_world_position_from_uv(SCREEN_UV, depth, INV_PROJECTION_MATRIX, INV_VIEW_MATRIX);
	
	// Ray from camera through this pixel
	vec3 ray_origin = CAMERA_POSITION_WORLD;
	vec3 ray_dir = normalize(world_pos - ray_origin);
	
	// Black hole position is the object's world position
	vec3 bh_center = NODE_POSITION_WORLD;
	
	// Calculate distance to black hole for effects
	float dist_to_bh = length(ray_origin - bh_center);
	
	// Intersect with the influence sphere (where lensing becomes noticeable)
	float influence_radius = black_hole_radius * 25.0;
	vec2 intersection = intersect_sphere(ray_origin, ray_dir, bh_center, influence_radius);
	
	vec3 final_color = vec3(0.0);
	float alpha = 0.0;
	float black_hole_mask = 0.0;
	
	// Only process if we're potentially looking at the black hole region
	if (intersection.x > 0.0 || intersection.y > 0.0) {
		// Raymarching setup
		float ray_dist = max(intersection.x, 0.0);
		float max_dist = intersection.y;
		
		vec3 current_ray_pos = ray_origin + ray_dir * ray_dist;
		vec3 current_ray_dir = ray_dir;
		
		// Track if we've hit anything in the disc
		float disc_mask = 0.0;
		vec3 disc_accumulated = vec3(0.0);
		float closest_approach = 1e10;
		
		// Raymarch through the gravitational field
		for (int i = 0; i < max_steps; i++) {
			if (ray_dist > max_dist) break;
			
			vec3 dir_to_center = bh_center - current_ray_pos;
			float dst_to_center = length(dir_to_center);
			closest_approach = min(closest_approach, dst_to_center);
			
			// Event horizon check - ray gets absorbed
			if (dst_to_center <= black_hole_radius) {
				black_hole_mask = 1.0;
				break;
			}
			
			// Soft event horizon falloff for antialiasing
			float falloff_zone = black_hole_radius * (1.0 + event_horizon_falloff);
			if (dst_to_center < falloff_zone && event_horizon_falloff > 0.0) {
				float proximity = 1.0 - (dst_to_center - black_hole_radius) / (falloff_zone - black_hole_radius);
				black_hole_mask = max(black_hole_mask, clamp(proximity, 0.0, 1.0));
			}
			
			// Accretion disc
			if (enable_disc && dst_to_center > disc_inner_radius && dst_to_center < disc_outer_radius) {
				// Check if ray crosses the disc plane
				vec3 norm_disc_up = normalize(disc_up_vector);
				float plane_dist = sd_plane(current_ray_pos - bh_center, norm_disc_up, 0.0);
				float next_plane_dist = sd_plane(
					(current_ray_pos + current_ray_dir * step_size) - bh_center, 
					norm_disc_up, 0.0
				);
				
				// Sign change indicates plane crossing
				if (plane_dist * next_plane_dist < 0.0) {
					// We're crossing the disc plane - calculate exact intersection
					float t_cross = -plane_dist / dot(current_ray_dir, norm_disc_up);
					vec3 cross_pos = current_ray_pos + current_ray_dir * t_cross;
					float disc_radius = length(cross_pos - bh_center);
					
					// Only if within disc radii
					if (disc_radius > disc_inner_radius && disc_radius < disc_outer_radius) {
						// Temperature gradient (hotter inside)
						float temp_grad = 1.0 - smoothstep(disc_inner_radius, disc_outer_radius, disc_radius);
						
						// Angle around disc for rotation/animation
						vec3 planar_pos = cross_pos - bh_center;
						vec3 perp = cross(norm_disc_up, planar_pos);
						float angle = atan(planar_pos.z, planar_pos.x);
						
						// Rotating turbulence pattern
						float time_angle = TIME * disc_rotation_speed;
						vec2 noise_uv = vec2(
							cos(angle + time_angle) * disc_radius,
							sin(angle + time_angle) * disc_radius
						);
						float turb = fbm(noise_uv * 3.0 + vec2(TIME * 0.1), 4);
						
						// Doppler beaming - brighter on approaching side
						vec3 rotated_pos = rotate_around_axis(planar_pos, norm_disc_up, 0.02);
						float doppler_shift = (length(rotated_pos - ray_origin) - length(planar_pos - ray_origin));
						float beaming = 1.0 + doppler_shift * disc_rotation_speed * doppler_factor * 50.0;
						beaming = clamp(beaming, 0.2, 3.0);
						
						// Disc color composition
						vec3 disc_base_color = mix(disc_color_outer, disc_color_inner, temp_grad);
						disc_base_color *= (1.0 + turb * turbulence_strength);
						disc_base_color *= beaming;
						
						// Inner edge brightness boost
						float inner_glow = exp(-5.0 * (disc_radius - disc_inner_radius) / disc_inner_radius);
						disc_base_color += disc_color_inner * inner_glow * 2.0;
						
						// Alpha based on temperature and turbulence
						float disc_alpha = temp_grad * (0.6 + turb * 0.4);
						disc_alpha *= smoothstep(disc_outer_radius, disc_outer_radius * 0.8, disc_radius);
						
						// Accumulate (simple alpha blending)
						float blend_factor = disc_alpha * (1.0 - disc_mask);
						disc_accumulated += disc_base_color * blend_factor * disc_brightness;
						disc_mask = min(disc_mask + disc_alpha, 1.0);
					}
				}
			}
			
			// Gravitational bending (inverse square law approximation)
			float norm_dst = max(dst_to_center / black_hole_radius, 0.001);
			float force = lensing_strength / (norm_dst * norm_dst);
			
			// Update ray direction (bending toward black hole)
			vec3 bend_dir = dir_to_center / dst_to_center;
			current_ray_dir = normalize(current_ray_dir + bend_dir * force * step_size);
			
			// Step forward
			current_ray_pos += current_ray_dir * step_size;
			ray_dist += step_size;
		}
		
		// Gravitational lensing of background
		// Calculate where the bent ray would hit the screen
		vec4 projected = PROJECTION_MATRIX * VIEW_MATRIX * vec4(current_ray_pos, 1.0);
		vec2 lensed_uv = (projected.xy / projected.w) * 0.5 + 0.5;
		
		// Check if lensed UV is valid
		bool valid_uv = all(greaterThanEqual(lensed_uv, vec2(0.0))) && all(lessThanEqual(lensed_uv, vec2(1.0)));
		
		// Sample background with lensing
		vec3 background_color;
		if (valid_uv) {
			background_color = texture(screen_tex, lensed_uv).rgb;
		} else {
			background_color = vec3(0.0); // Off-screen goes black
		}
		
		// Lensing intensity (stronger closer to black hole)
		float lensing_intensity = smoothstep(influence_radius, black_hole_radius * 3.0, closest_approach);
		lensing_intensity *= lensing_strength;
		
		// Einstein ring glow (brighten area just outside event horizon)
		float ring_glow = exp(-2.0 * abs(closest_approach - black_hole_radius * 3.0) / black_hole_radius);
		
		// Compose final color
		final_color = background_color * (1.0 - black_hole_mask * 0.9);
		final_color += vec3(ring_glow * 0.3, ring_glow * 0.2, ring_glow * 0.1); // Photon ring
		
		// Add accretion disc
		final_color += disc_accumulated;
		
		// Soft edge fade based on sphere intersection
		alpha = smoothstep(influence_radius, influence_radius * 0.5, dist_to_bh);
		alpha = max(alpha, black_hole_mask);
		alpha = max(alpha, disc_mask * 0.9);
		alpha = max(alpha, lensing_intensity * 0.3);
	} else {
		// No intersection with influence sphere, show original scene
		final_color = texture(screen_tex, SCREEN_UV).rgb;
	}
	
	// Final output
	ALBEDO = final_color;
	ALPHA = clamp(alpha, 0.0, 1.0);
}
