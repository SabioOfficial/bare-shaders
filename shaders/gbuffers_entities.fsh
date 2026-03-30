#version 330 compatibility

uniform sampler2D gtexture;
uniform float frameTimeCounter;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
  float t = frameTimeCounter;

  vec2 offset1 = vec2(sin(t * 10.0) * 0.02, 0.0);
  vec2 offset2 = vec2(0.0, cos(t * 10.0) * 0.02);
  
  vec4 mainBase = texture(gtexture, texcoord);
  vec4 ghost1 = texture(gtexture, texcoord + offset1);
  vec4 ghost2 = texture(gtexture, texcoord - offset2);
  
  vec3 finalRGB = mix(mainBase.rgb, ghost1.rgb, 0.4);
  finalRGB = mix(finalRGB, ghost2.rgb, 0.4);

  finalRGB *= 1.0 + sin(t * 20.0) * 0.3;

  color = vec4(finalRGB * glcolor.rgb, mainBase.a);
  if (color.a < 0.1) discard;
}