shader_type spatial;

uniform vec3 base_color : hint_color = vec3(1.0, 0.843, 0.0);  // Gold color
uniform float brightness : hint_range(0.0, 2.0) = 1.2;

void fragment() {
	// Apply gold color with brightness adjustment
	ALBEDO = base_color * brightness;
}
