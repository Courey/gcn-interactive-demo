shader_type canvas_item;

uniform vec4 player_color : source_color;
uniform float border_thickness = 0.05; // relative to UV space (0.0–1.0)

uniform vec2 resolution = vec2(1920, 1080);
uniform vec3 color: source_color = vec3(0.1,0.4,0.7);
uniform float zoom: hint_range(0.1, 3.0, 0.01) = 2.0;
uniform float speed:hint_range(0.0, 10.0, 0.01) = 2.0;
uniform float contrast: hint_range(1.0, 50.0, 0.01) = 20.0;
uniform float alpha_threshold:hint_range(0.0, 1.0, 0.1) = 0.2;
uniform bool is_observing = false;


void fragment() {
    // Distance from center (works well if UVs fill the shape)
    float dist_to_edge = min(min(UV.x, 1.0 - UV.x), min(UV.y, 1.0 - UV.y));

    if (dist_to_edge < border_thickness) {
        // Border (fully opaque)
        COLOR = player_color;
    } else {
        // Inside (50% transparent)
		if (is_observing) {
			vec2 uv = UV - 0.5;
			uv.x *= resolution.x / resolution.y;
			uv *= zoom;
			float time = TIME * speed;
			float r = length(uv);
			float wave = sin(r * r  + sin(r) - time) * sin(r);
			vec3 result = abs(1.0 / (wave * contrast))  * player_color.rgb;
			float avg = (result.r + result.g + result.b) / 3.0;
			COLOR = vec4(result, avg <= alpha_threshold ? 0.0 : 1.0);

		}
		else{
			COLOR = vec4(player_color.rgb, player_color.a * 0.5);
		}
    }
}
