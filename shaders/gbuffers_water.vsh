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

  float checkNV = (alwaysSober) ? 1.0 : clamp(nightVision + blindness, 0.0, 1.0);
  float active = (1.0 - clamp(checkNV, 0.0, 1.0)) * intensityMultiplier;

  if (active > 0.01) {
    float ripple = sin(t * 3.0 + position.x * 0.5 + position.z * 0.5);
    float swell = cos(t * 0.8 + position.x * 0.1 + position.z * 0.1) * 2.5;
    position.y += (ripple + swell) * active;
    position.xz += sin(t + position.y) * active;
  }

  gl_Position = gl_ProjectionMatrix * position;
  
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
  glcolor = gl_Color;
}