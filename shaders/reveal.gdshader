shader_type canvas_item;

uniform vec4 base_color: source_color = vec4(0.416, 0.133, 0.557, 0.533);
uniform sampler2D mask_tex : hint_default_white; // dynamically drawn texture
uniform float reveal_radius = 20.0;

void fragment() {
    vec4 mask = texture(mask_tex, UV);
    // mask_tex is white = visible, black = revealed/hidden
    COLOR = base_color * mask.r;
}