#version 330 compatibility

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