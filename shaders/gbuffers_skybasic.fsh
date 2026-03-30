#version 330 compatibility

uniform float frameTimeCounter;
uniform float nightVision;

in vec4 starColor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
  float t = frameTimeCounter;
  float active = 1.0 - clamp(nightVision, 0.0, 1.0);

  float cycle = fract(t / 30.0);

  float bloodIntensity = smoothstep(0.8, 0.9, cycle) * (1.0 - smoothstep(0.95, 1.0, cycle));
  bloodIntensity *= active;

  vec3 skyBase = starColor.rgb;
  vec3 bloodRed = vec3(0.7, 0.0, 0.0);

  vec3 finalSky = mix(skyBase, bloodRed, bloodIntensity);

  if (bloodIntensity > 0.1) {
    float scream = sin(t * 100.0) * 0.3;
    finalSky += scream;
  }

  float noise = fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453);
  finalSky = mix(finalSky, vec3(noise), 0.05 * active);

  color = vec4(finalSky, starColor.a);
}