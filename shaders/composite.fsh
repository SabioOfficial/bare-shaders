#version 330 compatibility

uniform sampler2D colortex0;
in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	float renderRes = 300.0;
	vec2 pixelatedUV = floor(texcoord * renderRes) / renderRes;
	vec4 scene = texture(colortex0, pixelatedUV);
	color = scene;
}