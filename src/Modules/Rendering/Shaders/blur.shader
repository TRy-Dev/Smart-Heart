shader_type canvas_item;

uniform float lod : hint_range(0.0, 5.0) = 1.0;

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod).rgb;
}