#version 330 compatibility

// #define ALWAYS_SOBER
// #define LESS_INTENSE

#ifdef ALWAYS_SOBER
  const bool alwaysSober = true;
#else
  const bool alwaysSober = false;
#endif

#ifdef LESS_INTENSE
  const float intensityMultiplier = 0.01;
#else
  const float intensityMultiplier = 1.0;
#endif

uniform sampler2D lightmap;
uniform sampler2D gtexture;
uniform float frameTimeCounter;
uniform float nightVision; 
uniform float blindness;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
  float t = frameTimeCounter;
  vec2 uv = texcoord;
  float sobriety = clamp(nightVision + blindness, 0.0, 1.0);
  float addictionFactor = 1.0 - sobriety;
  float waveX = sin(uv.y * 20.0 + t * 5.0) * 0.02 * addictionFactor;
  float waveY = cos(uv.x * 20.0 + t * 4.0) * 0.02 * addictionFactor;
  uv += vec2(waveX, waveY);
  vec4 tex = texture(gtexture, uv) * glcolor;
  tex *= texture(lightmap, lmcoord);
  if (tex.a < 0.1) discard;
  color = tex;
}