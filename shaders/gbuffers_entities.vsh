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
    float partID = fract(gl_Vertex.y * 1.5 + gl_Vertex.x);
    float angle = t * 6.0 * active * (partID > 0.5 ? 1.0 : -1.0);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    
    if (partID > 0.3) {
      position.xz *= 1.0 + (sin(t * 5.0) * 0.4 * active);
      position.xy = rot * position.xy;
      position.z += sin(t * 12.0 + gl_Vertex.y) * 0.6 * active;
    }
    
    position.xyz += sin(t * 30.0 + position.xyz) * 0.08 * active;
  }

  gl_Position = gl_ProjectionMatrix * position;
  
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
  glcolor = gl_Color;
}