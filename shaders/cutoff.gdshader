shader_type canvas_item;
uniform float cutoff = 0.5;

void fragment() {
    if (UV.y > cutoff) {
        discard;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}