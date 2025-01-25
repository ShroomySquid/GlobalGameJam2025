// Available at: https://godotshaders.com/shader/distortion-bubble/
shader_type spatial;
<<<<<<< HEAD
render_mode diffuse_toon;
=======
>>>>>>> bf8f8ce (Shader stuff)

// fragment uniforms
uniform float distortionView : hint_range(0.0, 0.3, 0.005) = 0.03;
uniform float speedView : hint_range(0.0, 1.0, 0.005) = 0.5;
uniform sampler2D noiseViewX;
uniform sampler2D noiseViewY;
uniform sampler2D screenTexture : hint_screen_texture;
uniform vec3 tintColor : source_color;
<<<<<<< HEAD
uniform vec3 pulseColor : source_color;
=======
>>>>>>> bf8f8ce (Shader stuff)
uniform float fesnelAmount : hint_range(0.0, 5.0, 0.1);
uniform float pulse_frequency : hint_range(0.1, 10.0) = 2.0;

// vertex uniforms
uniform float distortionVertex : hint_range(0.0, 0.3, 0.005) = 0.03;
uniform float speedVertex : hint_range(0.0, 1.0, 0.005) = 0.1;
uniform sampler2D noiseVertex;

<<<<<<< HEAD
uniform float scale : hint_range(0.1, 10.0) = 1.0;
uniform float shield_power : hint_range(0.0, 1.0) = 0.8;
uniform float rim_power : hint_range(0.0, 5.0) = 2.0;

float noise(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898, 78.233, 45.5432))) * 43758.5453);
}

float fbm(vec3 p) {
    float value = 1.0;
    float amplitude = 0.15;
    float frequency = 0.05;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}
=======
uniform float shield_power : hint_range(0.0, 1.0) = 0.8;
>>>>>>> bf8f8ce (Shader stuff)

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void vertex()
{
	float noiseVal = (texture(noiseVertex, UV + (TIME * speedVertex)).r * 2.0) - 1.0; // Range: -1.0 to 1.0
	vec3 displacement = NORMAL * noiseVal * distortionVertex;
	VERTEX = VERTEX + displacement;
}

void fragment() 
{
	float noiseValueX  = (texture(noiseViewX, UV + (TIME * speedView)).r * 2.0) - 1.0; // Range: -1.0 to 1.0
	float noiseValueY  = (texture(noiseViewY, UV + (TIME * speedView)).r * 2.0) - 1.0; // Range: -1.0 to 1.0
	vec2 noiseDistort = vec2(noiseValueX, noiseValueY) * distortionView;
	vec3 distortedScreenTexture = vec3(texture(screenTexture, SCREEN_UV + noiseDistort).rgb);
	vec3 fesnelTint = (tintColor * fresnel(fesnelAmount, NORMAL, VIEW));
	vec3 finalColor = distortedScreenTexture + fesnelTint;
<<<<<<< HEAD


	// Combine effects
	float pulse = (sin(TIME * pulse_frequency) + 1.0) * 0.5;
	vec3 noise_pos = VERTEX * scale + vec3(0.0, 0.0, TIME * speedView);
    float noise_val = fbm(noise_pos);
	vec3 view_dir = normalize(VIEW);
    vec3 normal = normalize(NORMAL);
	float fresnelPulse = pow(1.0 - dot(normal, view_dir), rim_power);
    float shield_intensity = mix(shield_power, 1.0, fresnelPulse);
    shield_intensity *= mix(0.8, 1.2, noise_val);
    shield_intensity *= mix(0.9, 1.1, pulse);
    
    // Color mixing
    vec3 final_color = mix(finalColor, pulseColor, pulse * 0.5);
    final_color.rgb *= shield_intensity;
    
	
	ALBEDO =  final_color.rgb;
	// material properties
    EMISSION = finalColor.rgb * shield_intensity;
    ALPHA = clamp(shield_intensity * 1.5, 0.0, 1.0);
    ROUGHNESS = 0.3;
=======
	ALBEDO = distortedScreenTexture + fesnelTint;
	// material properties
	float pulse = (sin(TIME * pulse_frequency) + 1.0) * 0.5;
	float shield_intensity = mix(shield_power, 1.0, fresnel(fesnelAmount, NORMAL, VIEW));
    shield_intensity *= mix(0.8, 1.2, noiseValueX);
    shield_intensity *= mix(0.9, 1.1, pulse);
    //EMISSION = finalColor.rgb * shield_intensity * 2.0;
    ALPHA = clamp(shield_intensity * 1.5, 0.0, 1.0);
    ROUGHNESS = 0.1;
>>>>>>> bf8f8ce (Shader stuff)
    METALLIC = 0.8;
}