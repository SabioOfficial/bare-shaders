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

uniform float frameTimeCounter;
uniform float nightVision;

out vec2 texcoord;
out vec4 glcolor;

void main() {
  vec4 position = gl_ModelViewMatrix * gl_Vertex;
  float t = frameTimeCounter;

  float active = 1.0 - clamp(nightVision, 0.0, 1.0);

  if (active > 0.5) {
    float stretch = sin(t * 5.0 + position.y * 10.0) * 0.2;
    position.x += stretch;
    position.z += cos(t * 3.0) * 0.1;

    position.xyz += sin(t * 100.0) * 0.01;
  }

  gl_Position = gl_ProjectionMatrix * position;
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  glcolor = gl_Color;
}