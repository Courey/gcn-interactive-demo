shader_type canvas_item;

uniform sampler2D mask_tex : hint_default_white; // dynamically drawn texture
uniform float reveal_radius = 20.0;

void fragment() {
    vec4 mask = texture(mask_tex, UV);
    // mask_tex is white = visible, black = revealed/hidden
    COLOR = vec4(1.0, 1.0, 0.5, 0.5) * mask.r;
}
