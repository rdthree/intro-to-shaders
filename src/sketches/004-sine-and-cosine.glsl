// Set the precision for floating point operations to high
precision highp float;

// UV coordinates passed from the vertex shader
varying vec2 vUv;
// Uniform float representing time, likely updated each frame
uniform float uTime;

// Function to normalize a sine wave to the range of 0 to 1
// This is useful for creating smooth transitions and oscillations in the shader
float normalSin(float val) {
  return sin(val) * 0.5 + 0.5;
}

// Function to create a color palette using trigonometric functions
// This allows for dynamic, smoothly changing colors in the shader
// 't' is a variable factor (like time) influencing the color changes
// 'a', 'b', 'c', 'd' are vec3 colors that mix together to produce the final color
vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  float twoPi = 6.28318; // Represents a full cycle (2 * PI)
  return a + b * cos(twoPi * (c * t + d)); // Color blending using cosine
}

void main(){
  vec2 uv = vUv; // Copy UV coordinates to local variable
  vec3 color = vec3(1.0); // Initialize color to white

  // Modify UV coordinates to create a wavy grid pattern
  // Multiplying UV coordinates by a larger number increases the frequency of the waves
  float freqX = 50.5;
  float freqY = 60.5;
  uv.x = normalSin(uv.x * freqX);
  uv.y = normalSin(uv.y * freqY);

  // Calculate a moving position based on time for dynamic effects
  // 'pos' is a 2D vector that represents a point moving in a circular path.
  // The circular motion is achieved by using the sine and cosine functions.
  // 'cos(uTime)' and 'sin(uTime)' generate values from -1 to 1 as 'uTime' changes.
  // When plotted on a graph, 'cos' gives the x-coordinate, and 'sin' gives the y-coordinate.
  // These coordinates trace out a circle because 'cos' and 'sin' are the base functions
  // for defining a circle in polar coordinates. As 'uTime' increases linearly,
  // the output of 'cos' and 'sin' moves along the circumference of a circle.
  // For every value of 'uTime', 'cos(uTime)' represents the horizontal distance
  // from the center of the circle, and 'sin(uTime)' represents the vertical distance.
  // Multiplying both values by 0.2 scales the radius of the circle to be smaller.
  // This results in a smooth, continuous circular motion, which is a common technique
  // in shaders for creating dynamic, cyclical animations.
  vec2 pos = vec2(cos(uTime) * 5.0, sin(uTime) * 5.0) * 0.15;

  // Determine the size change of a circle over time for animation
  float sizeChange = sin(uTime * 2.0) * 0.2;

  // Creating a circle with a smooth edge using smoothstep and distance
  // The circle is formed based on the distance of each pixel from a central point.
  // 'distance(vec2(0.5), uv + pos)' calculates this distance, acting as the radius.
  // A circle is defined by all pixels at a specific distance (radius) from this center.
  // 'smoothstep(edge0, edge1, x)' is used to soften the edges of this circle.
  // It interpolates smoothly between 0 and 1 as 'x' (the distance) crosses between
  // 'edge0' (0.2 + sizeChange) and 'edge1' (0.4 + sizeChange).
  // This creates a gradient at the circle's edge: 
  // - Pixels closer than 'edge0' are inside the circle and almost fully colored.
  // - Pixels beyond 'edge1' are outside the circle and not colored (or retain background color).
  // - Only pixels within 'edge0' and 'edge1' get values between 0 and 1, 
  //   creating the soft edge effect.
  // The rest of the shader uses these values to color the circle and its edges.
  // Pixels within the circle are colored more intensely, while those outside remain less colored.
  float circle = smoothstep(0.15 + sizeChange, 0.45 + sizeChange, distance(vec2(0.5), uv + pos));

  // Initialize result to store the intensity of the circle pattern
  float result = 0.0;
  result += circle; // Add the circle pattern's intensity to the result

  // Convert the result (a float) to a grayscale color (vec3)
  // Each component of the vec3 is set to the value of result
  color = vec3(result);

  // Invert the result for a complementary color effect inside the shapes
  result = 1.0 - result;

  // Apply the color palette for dynamic coloring
  // 'paletteOffset' combines UV coordinates and time for color variation.
  // 'uv.x * 0.3' and 'uv.y' use pixel position for color variation.
  // 'uTime * 0.2' allows color to change over time.
  float paletteOffset = uv.x * 0.3 + uv.y + uTime * 0.2;

  // 'offset' sets a base color, here a mid-tone grey.
  vec3 offset = vec3(0.5, 0.5, 0.5);

  // Applying the palette function:
  // 'palette' function creates time-varying color effects.
  // It blends colors based on 'paletteOffset' and other parameters.
  // The result of 'palette' is modulated by 'result' (pattern intensity).
  // This ensures color application matches the intensity of the pattern.
  // High intensity in the pattern gets stronger color, low intensity gets less.
  color = result * palette(paletteOffset, offset, offset, vec3(0.2, 0.1, 0.0), vec3(0.5, 0.2, 0.25));

  // The final color of each pixel is thus a mix of the pattern intensity
  // and the dynamically changing colors from the palette function.


  // Set the final color of the pixel
  gl_FragColor = vec4(color, 1.0);

  // Below are additional commented-out gradient effects
  // Uncomment them one at a time to see different visual effects
  
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

