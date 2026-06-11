shader_type spatial;
uniform vec3 gold_color = vec3(1.0, 0.843, 0.0);
uniform float brightness : hint_range(0.0, 2.0) = 1.2;
void fragment() {
	ALBEDO = gold_color * brightness;
}