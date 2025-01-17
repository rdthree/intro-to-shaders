precision highp float;

varying vec2 vUv;
uniform float uTime;

void main(){
    vec3 color = vec3(0.0);
    vec2 uv = vUv;
    
    //horizontal bw gradient
    //color = vec3(uv.x);
    
    //vertical bw gradient
    //color = vec3(uv.y);
    
    //pulsate!
    //color = vec3(fract(uTime));
    
    // red half blue half
    color = vec3(1.0, 0.0, 0.0);
    if (vUv.x > 0.5) {
        color = vec3(0.0, 0.0, 1.0);
    }
    
    gl_FragColor = vec4(color, 1.0);
}