shader_type canvas_item;

uniform vec2 resolution = vec2(1920.0, 1080.0);
uniform sampler2D noise_texture: filter_nearest, repeat_enable;
uniform float density: hint_range(1.0, 100.0, 0.1) = 20.0;
void fragment() {
	vec2 uv = UV;
	uv.x *= resolution.x / resolution.y;
	float stars = 0.0;
	stars += pow(texture(noise_texture, uv).r, density);
	COLOR = vec4(vec3(stars), 1.0);
	// Called for every pixel the material is visible on.
}
