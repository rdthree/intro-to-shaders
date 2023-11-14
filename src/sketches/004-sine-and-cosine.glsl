precision highp float;

varying vec2 vUv;
uniform float uTime;

// transformation: reduces amplitude to 0.5, then move the whole wave into 0 to 1
float normalSin(float val) {
  return sin(val) * 0.5 + 0.5;
}

void main(){
  vec2 uv = vUv;
  vec3 color = vec3(1.);
  
  // transformation: reduces amplitude to 0.5, then move the whole wave into 0 to 1
  float edge = sin(uTime) * 0.5 + 0.5;
  
  float gradient = 0.0;
  // angle
  //gradient = step(uv.y - sin(uTime), uv.x);
  // horizontal
  //gradient = step(sin(uTime), uv.x);
  //vertical
  gradient = step(uv.y, sin(uTime));
  vec3 result = vec3(gradient);

  gl_FragColor = vec4(result, 1.0);
}

