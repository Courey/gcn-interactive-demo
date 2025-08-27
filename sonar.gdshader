shader_type canvas_item;

uniform vec2 resolution = vec2(1920, 1080);
uniform vec3 color: source_color = vec3(0.1,0.4,0.7);
uniform float zoom: hint_range(0.1, 3.0, 0.01) = 2.0;
uniform float speed:hint_range(0.0, 10.0, 0.01) = 2.0;
uniform float contrast: hint_range(1.0, 50.0, 0.01) = 20.0;
uniform float alpha_threshold:hint_range(0.0, 1.0, 0.1) = 0.0; 

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	uv *= zoom;
	float time = TIME * speed;
	float r = length(uv);
	float wave = sin(r * r  + sin(r) - time) * sin(r);
	vec3 result = abs(1.0 / (wave * contrast))  * color;
	float avg = (result.r + result.g + result.b) / 3.0;
	COLOR = vec4(result, avg <= alpha_threshold ? 0.0 : 1.0);
}

