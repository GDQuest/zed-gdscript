shader_type canvas_item;
render_mode unshaded, light_only;

#include "some_include.gdshaderinc"

// Types.

struct PointLight {
	vec3 position;
	vec3 color;
	float intensity;
};

// Constants.

const float GOLDEN_RATIO = 1.618033988749894;

// Uniforms.

uniform float blur_amount: hint_range(0.0, 10.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

group_uniforms stripes;
uniform int stripes_orientation: hint_range(0, 1) = 0;
uniform highp vec4 stripes_direction = vec4(0.0, 1.0, 2.0, 3.0);
group_uniforms stripes.speed;
uniform mediump float stripes_speed = 1.0;
group_uniforms;

global uniform mat3 transform;
instance uniform vec4 my_color: source_color = vec4(1.0, 0.5, 0.0, 1.0);

// Varyings.

varying float saturation;
varying flat int frame_index;
varying lowp vec4 light_data;
varying PointLight point_light;

// Built-in methods.

void fragment() {
	float float_arr[3] = float[3] (1.0, 0.5, 0.0);
	int int_arr[3] = int[] (2, 1, 0);
	vec2 vec2_arr[3] = { vec2(1.0, 1.0), vec2(0.5, 0.5), vec2(0.0, 0.0) };
	bool bool_arr[] = { true, true, false };

	vec4 blurred = texture(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
	COLOR = vec4(blurred.rgb, 1.0);

	if (saturation > 0.5) {
		COLOR.a = 0.45;
	}
}

void light() {
	PointLight light;
	light.position = vec3(0.0);
	light.color = vec3(1.0, 0.0, 0.0);
	light.intensity = 0.5;

#if defined(SHADOW_QUALITY_HIGH)
	// High shadow quality.
#elif defined(SHADOW_QUALITY_MEDIUM)
	// Medium shadow quality.
#else
	// Low shadow quality.
#endif
}

// Custom methods.

// Based on https://github.com/ttencate/blur_godot4/blob/0517d1159b088a272300b083ae98376d9d77ffea/Blur.gdshader.
float blur(sampler2D source, vec2 uv, vec2 direction, float intensity) {
	vec2 s = intensity * direction / vec2(textureSize(source, 0));

	float blurred =
		0.011194727 * texture(source, uv - 10.000000000 * s).a +
		0.039368696 * texture(source, uv - 8.415809477 * s).a +
		0.071308558 * texture(source, uv - 6.435363708 * s).a +
		0.110237219 * texture(source, uv - 4.455121108 * s).a +
		0.145451038 * texture(source, uv - 2.475020813 * s).a +
		0.163798995 * texture(source, uv - 0.495000167 * s).a +
		0.157439298 * texture(source, uv + 1.485004498 * s).a +
		0.129158204 * texture(source, uv + 3.465057055 * s).a +
		0.090434685 * texture(source, uv + 5.445220765 * s).a +
		0.054043977 * texture(source, uv + 7.425557483 * s).a +
		0.027564604 * texture(source, uv + 9.406126897 * s).a;

	// Allows to disable the effect completely at the cost of being applied twice.
	blurred *= intensity;

	return blurred;
}

// Custom defines.

#define CONSUME_INSTANCE_DATA                   \
	if (use_overrides) {                        \
		variant_index = variant_index_override; \
		frame_index = frame_index_override;     \
		opacity = opacity_override;             \
		saturation = saturation_override;       \
	} else {                                    \
		variant_index = int(INSTANCE_CUSTOM.r); \
		frame_index = int(INSTANCE_CUSTOM.g);   \
		opacity = INSTANCE_CUSTOM.b;            \
		saturation = 1.0;                       \
	}

#define TEXTURE_FRAME_FUNC(name)                                                       \
vec4 name(sampler2D source, vec2 uv, int fidx) {                                       \
	vec2 sample_uv = uv;                                                               \
	sample_uv.x = (sample_uv.x + float(fidx % frame_count.x)) / float(frame_count.x);  \
	sample_uv.y = (sample_uv.y + float(fidx / frame_count.x)) / float(frame_count.y);  \
                                                                                       \
	return texture(source, sample_uv);                                                 \
}
TEXTURE_FRAME_FUNC(texture_frame)
TEXTURE_FRAME_FUNC(texture_frame2)
