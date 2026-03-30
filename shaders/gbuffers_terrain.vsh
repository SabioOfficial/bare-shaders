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

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;

uniform float frameTimeCounter;
uniform float nightVision;
uniform float blindness;

void main() {
  vec4 position = gl_ModelViewMatrix * gl_Vertex;
  float t = frameTimeCounter;

  float active = 1.0 - clamp(nightVision + blindness, 0.0, 1.0);
  if (alwaysSober) active = 0.0;
  active *= intensityMultiplier;

  if (active > 0.0001) {
    float distanceSq = dot(position.xyz, position.xyz);
    position.y += sin(t * 0.5 + position.x * 0.1) * (distanceSq * 0.001 * active);
    position.x += cos(t * 0.3 + position.z * 0.1) * (distanceSq * 0.001 * active);
  }

  gl_Position = gl_ProjectionMatrix * position;
  
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
  glcolor = gl_Color;
}