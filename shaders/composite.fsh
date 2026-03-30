#version 330 compatibility

uniform sampler2D colortex0;
in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	float renderRes = 300.0;
	vec2 pixelatedUV = floor(texcoord * renderRes) / renderRes;
	vec4 scene = texture(colortex0, pixelatedUV);
	vec3 rgb = scene.rgb;
	float brightnessBoost = 1.05;
	rgb *= brightnessBoost;
	rgb = pow(rgb, vec3(0.8));
	rgb = (rgb - 0.5) * 1.1 + 0.5;
	color = vec4(clamp(rgb, 0.0, 1.0), scene.a);
}