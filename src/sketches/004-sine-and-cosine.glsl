precision highp float;

varying vec2 vUv;
uniform float uTime;

// normalize: reduces amplitude to 0.5, then move the whole wave into 0 to 1
float normalSin(float val) {
  return sin(val) * 0.5 + 0.5;
}

// color palette based on sin/cos
vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  float twoPi = 6.28318;
  return a + b * cos( twoPi * (c * t + d));
}



void main(){
  vec2 uv = vUv;
  vec3 color = vec3(1.0);
  
  // modify UV's, bigger number means more grids, idunno why
  uv.x = normalSin(uv.x * 10.5);
  uv.y = normalSin(uv.y * 10.5);
  
  vec2 pos = vec2(cos(uTime), sin(uTime)) * 0.2;
  
  float sizeChange = sin(uTime * 2.0) * 0.2;
  float circle = smoothstep(0.2 + sizeChange, 0.4 + sizeChange, distance(vec2(0.5), uv + pos));
  float result = 0.0;
  result += circle;
  color = vec3(result);
  // color inside the shapes, not the other way around
  result = (1.-result);

  //draw it up with the palette
  float paletteOffset = uv.x * 0.3 + uv.y + uTime * 0.2;
  vec3 offset = vec3(0.5,0.5,0.5);
  color = result * palette(paletteOffset, offset, offset, vec3(0.2,0.1,0.0), vec3(0.5,0.2,0.25));
  gl_FragColor = vec4(color, 1.0);
  
  //old edge not normalized
  float oldEdge = sin(uTime);
  //edge normalized
  float edge = normalSin(uTime);
  //infinite gradient
  float infinite = normalSin(uv.x + uTime);
  //infinite, frequent, fast
  float fastFrequent = sin(uv.x * 0.4 + uTime * 8.0) * 0.5 + 0.5;
  float gradient = 0.0;
  // angle
  //gradient = step(uv.y - sin(uTime), uv.x);
  // horizontal
  //gradient = step(sin(uTime), uv.x);
  //vertical
  //gradient = step(uv.y, sin(uTime));
  
  //vec3 result = vec3(oldEdge);
  //vec3 result = vec3(edge);
  //vec3 result = vec3(infinite);
  //vec3 result = vec3(fastFrequent);
  //gl_FragColor = vec4(result, 1.0);
}

