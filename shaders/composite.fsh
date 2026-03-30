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

uniform sampler2D gcolor; 
uniform sampler2D gdepthtex; 
uniform mat4 gbufferProjectionInverse; 
uniform float frameTimeCounter; 
uniform float nightVision; 
uniform float blindness;

uniform bool is_sprinting;
uniform bool is_sneaking;
uniform bool is_hurt;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

float getLinearDepth(vec2 uv) {
  float depth = texture(gdepthtex, uv).r;
  vec4 ndcPos = vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
  vec4 viewPos = gbufferProjectionInverse * ndcPos;
  return -(viewPos.z / viewPos.w);
}

void main() {
  float dist = getLinearDepth(texcoord);
  float t = frameTimeCounter;

  float active = 1.0 - clamp(nightVision + blindness, 0.0, 1.0);
  if (alwaysSober) active = 0.0;
  active *= intensityMultiplier;

  if (active < 0.0001) {
    color = texture(gcolor, texcoord);
    return;
  }

  float chaosBase = clamp(1.0 - (dist / 35.0), 0.0, 1.0);
  float chaos = (0.8 + (0.2 * pow(chaosBase, 1.0))) * active; 
  
  vec2 uv = texcoord - 0.5;

  if (is_sprinting && active > 0.5) {
    uv *= 0.85;
    uv.x += sin(t * 15.0) * 0.005;
  }

  if (is_sneaking && active > 0.5) {
    float fps = 10.0;
    t = floor(t * fps) / fps;
  }

  if (chaos > 0.5 && fract(t * 0.2) > 0.9) {
    uv *= -1.0; 
  }

  float splitDirection = (texcoord.y > 0.5) ? 1.0 : -1.0;
  uv.x += (sin(t * 3.0) * 0.15 * chaos) * splitDirection;

  float perspective = 1.0 + sin(t * 2.0) * 0.5 * chaos;
  uv /= (1.0 + length(uv) * perspective);

  float a = cos(t * 1.6) * chaos;
  float b = sin(t * 2.1) * chaos;
  float c = -sin(t * 1.9) * chaos;
  float d = cos(t * 1.4) * chaos;
  mat2 M = mat2(1.0 + a, c, b, 1.0 + d);
  uv = M * uv;

  if (chaos > 0.9) {
    uv = mix(uv, fract(uv * 3.0) - 0.5, 0.4);
  }

  float res1 = mix(1000.0, 8.0, chaos); 
  float res2 = mix(1000.0, 12.0, chaos); 
  vec2 pUV = floor(uv * res1) / res1;
  pUV = floor(pUV * res2) / res2;
  pUV += 0.5;

  float shift = 0.1 * chaos;
  if (is_sprinting) shift += 0.05;

  vec3 rgb;
  rgb.r = texture(gcolor, pUV + vec2(shift * sin(dist), 0.0)).r;
  rgb.g = texture(gcolor, pUV + vec2(0.0, shift * cos(dist))).g;
  rgb.b = texture(gcolor, pUV + vec2(-shift, -shift)).b;

  rgb = fract(rgb * (1.0 + 2.0 * chaos) + (t * chaos)); 

  float det = (M[0][0] * M[1][1]) - (M[0][1] * M[1][0]);
  if (det < 0.05 || (chaos > 0.95 && fract(t * 40.0) > 0.5)) {
    rgb = rgb.gbr;
    rgb = 1.0 - rgb; 
  }

  float levels = mix(255.0, 2.0, chaos);
  rgb = floor(rgb * levels) / levels;

  if (is_hurt && active > 0.5) {
    rgb.r *= 1.5;
    rgb.gb *= 0.5;
  }

  float pseudoFloor = fract(sin(dot(pUV * dist, vec2(12.9898, 78.233))) * 43758.5453);
  rgb = mix(rgb, vec3(pseudoFloor), 0.2 * chaos);

  rgb *= mix(1.0, 1.7, chaos);
  rgb = pow(rgb, vec3(mix(1.0, 0.6, chaos)));

  color = vec4(clamp(rgb, 0.0, 1.0), 1.0);
}