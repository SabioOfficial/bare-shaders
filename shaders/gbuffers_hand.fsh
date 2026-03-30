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

uniform sampler2D gtexture;
uniform float frameTimeCounter;
uniform float nightVision;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
  float t = frameTimeCounter;
  float active = 1.0 - clamp(nightVision, 0.0, 1.0);

  float noise = fract(sin(dot(texcoord + t, vec2(12.9898, 78.233))) * 43758.5453);
  if (active > 0.5 && noise > 0.8) {
    discard;
  }

  vec4 tex = texture(gtexture, texcoord);
  vec3 rgb = tex.rgb * glcolor.rgb;

  if (active > 0.5) {
    rgb.r = texture(gtexture, texcoord + vec2(0.01 * sin(t * 10.0), 0.0)).r;
    rgb.b = texture(gtexture, texcoord - vec2(0.01 * cos(t * 10.0), 0.0)).b;
    if (fract(t * 2.0) > 0.9) {
      rgb = 1.0 - rgb;
    }
    rgb.g += sin(t * 20.0) * 0.2;
  }

  color = vec4(rgb, tex.a * glcolor.a);
}