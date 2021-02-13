shader_type canvas_item;

uniform float value :hint_range(0.0, 1.0) = 0.5;
uniform vec2 start_pos = vec2(0.0, 0.0);
uniform vec2 end_pos = vec2(1.0, 1.0);

void fragment() {
	float a = 1.0;
	if (UV.x + 1.0 - UV.y > value * 2.0) {
		a = 0.0;
	}
	vec4 tex = texture(TEXTURE, UV);
	COLOR = vec4(tex.rgb, min(a, tex.a));
}