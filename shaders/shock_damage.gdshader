shader_type canvas_item;

/**
Color to use for the shock.
*/
uniform vec3 shock_color : source_color = vec3(1.0, 0.0, 0.0);
/**
Initial amplitude of the shock. This will start at this amplitude and
gradually attenuate.
*/
uniform float amplitude = 30.0;
/**
How fast should it move side to side, more frequency means it'll move more quickly
side to side.
*/
uniform float frequecy = 10.0;
/**
Boolean to trigger the shock effect.
Set this to true to start the effect.
*/
uniform bool trigger_shock = false;

/**
Manual time progression for the shock effect.
This should be incremented externally from code while `trigger_shock` is true.
*/
uniform float shock_time = 0.0;

void vertex() {
	float exponent = mod(shock_time, 3.0);
	VERTEX.x += amplitude * exp(-3.0 * exponent) * sin(frequecy * exponent);
}

void fragment() {
	if (trigger_shock) {
		float exponent = mod(shock_time, 3.0);
		vec3 normal_color = texture(TEXTURE, UV).rgb;
		COLOR.rgb = normal_color + shock_color * exp(-3.0 * exponent);
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}