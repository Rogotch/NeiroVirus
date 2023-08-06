shader_type canvas_item;


uniform vec4 original_0: source_color;
uniform vec4 original_1: source_color;
uniform vec4 original_2: source_color;
uniform vec4 original_3: source_color;
uniform vec4 original_4: source_color;
uniform vec4 original_5: source_color;
uniform vec4 original_6: source_color;
uniform vec4 original_7: source_color;
uniform vec4 original_8: source_color;
uniform vec4 replace_0: source_color;
uniform vec4 replace_1: source_color;
uniform vec4 replace_2: source_color;
uniform vec4 replace_3: source_color;
uniform vec4 replace_4: source_color;
uniform vec4 replace_5: source_color;
uniform vec4 replace_6: source_color;
uniform vec4 replace_7: source_color;
uniform vec4 replace_8: source_color;

const float precision = 0.1;


vec4 swap_color(vec4 color){
	vec4 original_colors[9] = vec4[9] (original_0, original_1, original_2, original_3, original_4, original_5, original_6, original_7, original_8);
	vec4 replace_colors[9] = vec4[9] (replace_0, replace_1, replace_2, replace_3, replace_4, replace_5, replace_6, replace_7, replace_8);
	for (int i = 0; i < 9; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}


void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV));
}