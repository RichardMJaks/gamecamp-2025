shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(0.2, 0.6, 1.0, 0.8);
uniform float line_width : hint_range(1.0, 10.0) = 2.0;
uniform float pulse_speed : hint_range(0.1, 5.0) = 1.5;
uniform float dash_size : hint_range(0.0, 20.0) = 5.0;
uniform float dash_gap : hint_range(0.0, 20.0) = 5.0;

void fragment() {
    // Calculate distance from the center line
    float center_dist = abs(UV.y - 0.5) * 2.0;

    // Apply line width
    float line_alpha = 1.0 - smoothstep(line_width / 100.0, line_width / 50.0, center_dist);

    // Create pulsing effect
    float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5;

    // Create dashed line effect
    float dash_pattern = mod(UV.x * 100.0, dash_size + dash_gap);
    float dash_alpha = dash_pattern < dash_size ? 1.0 : 0.0;

    // Combine effects
    COLOR = line_color;
    COLOR.a *= line_alpha * (0.5 + pulse * 0.5) * dash_alpha;
}