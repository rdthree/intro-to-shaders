precision highp float;

varying vec2 vUv;
uniform float uTime;

float squareMaker(vec2 uv, float size) {
  float halfSize = size / 2.0;
  float bottom = step(uv.y, 0.5 + halfSize);
  float top = step(0.5 - halfSize, uv.y);
  float left = step(0.5 - halfSize, uv.x);
  float right = step(uv.x, 0.5 + halfSize);

  return left * right * top * bottom;
}

void main() {
  vec3 color = vec3(1.);
  vec2 uv = vUv;

  //create a square
  //float bottom = step(0.3, uv.y);
  //float top = step(uv.y, 0.7);
  //float left = step(0.3, uv.x);
  //float right = step(uv.x, 0.7);

  //bw half half screen
  //float result = step(0.5, uv.x);

  //black is '0', so anything multiplied by 0 is 0
  //in other words, using multiplication, black is a mask
  //float square = bottom * top * left * right;
  //float result = square;

  //float result = squareMaker(uv, 0.9);
  //vec2 pos = vec2(0.4,0.1);
  //float result = squareMaker(uv + pos,0.89);
  float result = smoothstep(0.3, 0.7, uv.x);

  vec2 circlePos = vec2(cos(uTime), sin(uTime)) * 0.2;
  float sizeChange = sin(uTime) * 0.2;

  float circleGradient = distance(vec2(0.5), uv + circlePos);
  float circle = smoothstep(0.2 + sizeChange, 0.8, circleGradient);

  result = circle;

  color = vec3(result);

  gl_FragColor = vec4(color, 1.0);
}
