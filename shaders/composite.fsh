#version 330 compatibility

uniform sampler2D gcolor; 
uniform sampler2D gdepthtex; 
uniform mat4 gbufferProjectionInverse; 
uniform float frameTimeCounter; 

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

float getLinearDepth(vec2 uv) {
	float depth = texture(gdepthtex, uv).r;
	vec4 ndcPos = vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
	vec4 viewPos = gbufferProjectionInverse * ndcPos;
	return -(viewPos.z / viewPos.w);
}

void main() {
	float dist = getLinearDepth(texcoord);
	float t = frameTimeCounter;
	float chaos = clamp(1.0 - (dist / 35.0), 0.0, 1.0);
	chaos = 0.8 + (0.2 * pow(chaos, 1.0)); 
	vec2 uv = texcoord - 0.5;
	float perspective = 1.0 + sin(t * 2.0) * 0.5 * chaos;
	uv /= (1.0 + length(uv) * perspective);
	float a = cos(t * 1.6) * chaos;
	float b = sin(t * 2.1) * chaos;
	float c = -sin(t * 1.9) * chaos;
	float d = cos(t * 1.4) * chaos;
	mat2 M = mat2(1.0 + a, c, b, 1.0 + d);
	uv = M * uv;
	if (chaos > 0.9) {
		uv = mix(uv, fract(uv * 3.0) - 0.5, 0.4);
	}
	float res1 = mix(200.0, 8.0, chaos); 
	float res2 = mix(100.0, 12.0, chaos); 
	vec2 pUV = floor(uv * res1) / res1;
	pUV = floor(pUV * res2) / res2;
	pUV += 0.5;
	float shift = 0.1 * chaos;
	vec3 rgb;
	rgb.r = texture(gcolor, pUV + vec2(shift * sin(dist), 0.0)).r;
	rgb.g = texture(gcolor, pUV + vec2(0.0, shift * cos(dist))).g;
	rgb.b = texture(gcolor, pUV + vec2(-shift, -shift)).b;
	rgb = fract(rgb * 3.0 + t); 
	float det = (M[0][0] * M[1][1]) - (M[0][1] * M[1][0]);
	if (det < 0.05 || (chaos > 0.95 && fract(t * 40.0) > 0.5)) {
		rgb = rgb.gbr;
		rgb = 1.0 - rgb; 
	}
	float levels = mix(8.0, 2.0, chaos);
	rgb = floor(rgb * levels) / levels;
	float pseudoFloor = fract(sin(dot(pUV * dist, vec2(12.9898, 78.233))) * 43758.5453);
	rgb = mix(rgb, vec3(pseudoFloor), 0.2 * chaos);
	rgb *= 1.7;
	rgb = pow(rgb, vec3(0.6));
	color = vec4(clamp(rgb, 0.0, 1.0), 1.0);
}