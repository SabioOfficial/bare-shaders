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

out vec4 glColor;

void main() {
  vec4 position = gl_ModelViewMatrix * gl_Vertex;
  float t = frameTimeCounter;

  float active = 1.0 - clamp(nightVision, 0.0, 1.0);

  float angle = t * 0.5 * active;
  mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

  position.xz = rot * position.xz;
  position.y += sin(t * 2.0) * 5.0 * active;

  gl_Position = gl_ProjectionMatrix * position;
  glColor = gl_Color;
}