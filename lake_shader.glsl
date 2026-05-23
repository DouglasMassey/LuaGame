// Simple animated lake shader for top-down view
// Pixelated water effect with blue gradient sweeping from top to bottom

extern float time;
extern float pixelSize;      // Size of pixel blocks (default: 8.0)
extern float waveFrequency;  // How tight/spread the wave bands are (default: 0.01)
extern float waveSpeed;      // How fast the wave moves (default: 0.8)
extern float waveAmplitude;  // Wave height/intensity (default: 0.5)
extern float waveOffset;     // Centers the wave values (default: 0.5)
extern float colorThreshold; // Where to switch between color gradients (default: 0.5)

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Pixelate the coordinates for retro look
    vec2 pixelated = floor(screen_coords / pixelSize) * pixelSize;
    
    // Create a single wave gradient that sweeps from top to bottom
    // Using sin wave that moves down the screen over time
    float wave = sin(pixelated.y * waveFrequency - time * waveSpeed) * waveAmplitude + waveOffset;
    
    // Define blue color palette for lake
    vec3 deepBlue = vec3(0.1, 0.3, 0.6);      // Deeper water
    vec3 lightBlue = vec3(0.3, 0.6, 0.85);    // Lighter water
    vec3 highlightBlue = vec3(0.5, 0.7, 0.95); // Highlights
    
    // Create smooth gradient based on the wave
    vec3 waterColor;
    if (wave < colorThreshold) {
        waterColor = mix(deepBlue, lightBlue, wave / colorThreshold);
    } else {
        waterColor = mix(lightBlue, highlightBlue, (wave - colorThreshold) / (1.0 - colorThreshold));
    }
    
    return vec4(waterColor, 1.0);
}
