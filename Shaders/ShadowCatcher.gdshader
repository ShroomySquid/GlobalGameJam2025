shader_type spatial;

uniform float alpha : hint_range(0.0, 1.0);
uniform sampler2D bayer;

void fragment() {
	if (texture(bayer, FRAGCOORD.xy / 4.0).r > alpha) {
		discard;
	}
}