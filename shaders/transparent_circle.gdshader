shader_type canvas_item;

uniform vec2 resolution = vec2(1920.0, 1080.0);

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;

	float d = length(uv);
	float radius = .49;
	
	if (d < radius) {
		COLOR = vec4(0,0,0,0);
	} 
	else if (d < .5){
		COLOR = vec4(0.02, 0.04, 0.27,1);
	}
}
