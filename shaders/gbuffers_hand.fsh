#version 330 compatibility

uniform sampler2D gtexture;
uniform float frameTimeCounter;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
  float t = frameTimeCounter;

  vec2 jitter = vec2(
    sin(t * 80.0) * 0.005,
    cos(t * 75.0) * 0.005
  );

  vec3 rgb;
  rgb.r = texture(gtexture, texcoord + jitter).r;
  rgb.g = texture(gtexture, texcoord).g;
  rgb.b = texture(gtexture, texcoord - jitter).b;
  
  rgb *= 1.0 + sin(t * 10.0) * 0.2;

  color = vec4(rgb * glcolor.rgb, 1.0);
}