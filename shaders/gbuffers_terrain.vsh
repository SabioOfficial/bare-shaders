#version 330 compatibility

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;

uniform float frameTimeCounter;

void main() {
  vec4 position = gl_ModelViewMatrix * gl_Vertex;
  float t = frameTimeCounter;

  float distanceSq = dot(position.xyz, position.xyz);
  position.y += sin(t * 0.5 + position.x * 0.1) * (distanceSq * 0.001);
  position.x += cos(t * 0.3 + position.z * 0.1) * (distanceSq * 0.001);

  gl_Position = gl_ProjectionMatrix * position;
  
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
  glcolor = gl_Color;
}