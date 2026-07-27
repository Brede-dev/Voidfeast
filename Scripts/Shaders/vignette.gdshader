shader_type canvas_item;

// Vignette strength — how dark the edges get. 0 = no darkening, 1 = fully black.
uniform float strength: hint_range(0.0, 2.0) = 0.7;

// Vignette radius — how far from center the darkening starts (0..1).
// Lower values = vignette begins closer to the center.
uniform float radius: hint_range(0.0, 1.0) = 0.5;

// Softness — smoothness of the transition between clear center and darkened edges.
uniform float softness: hint_range(0.0, 1.0) = 0.4;

// Aspect ratio correction — keeps the vignette circular regardless of screen shape.
uniform bool preserve_aspect = true;

void fragment() {
	// Normalized UV with origin at top-left, shift to center
	vec2 center = UV - 0.5;

	// Aspect-ratio correction to keep the vignette circular
	if (preserve_aspect) {
		center.x *= TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
	}

	// Distance from center (0 at center, grows toward edges)
	float dist = length(center);

	// Vignette falloff: smoothstep from clear to dark
	// At dist < radius:     fully clear
	// At dist > radius + softness: fully dark
	float vignette_alpha = smoothstep(radius, radius + softness, dist);

	// Start from the ColorRect's vertex color (its `color` property)
	vec4 base = COLOR;

	// Darken toward black at the edges; keep center unchanged
	base.rgb = mix(base.rgb, vec3(0.0), vignette_alpha * strength);

	// Boost alpha at the edges so the darkening visibly overlays the screen
	base.a = max(base.a, vignette_alpha * strength);

	COLOR = base;
}
