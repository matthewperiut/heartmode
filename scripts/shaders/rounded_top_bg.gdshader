shader_type canvas_item;

uniform bool use_white = true;
uniform float corner_radius = 10.0;
uniform vec2 rect_size = vec2(500.0, 500.0);

void fragment() {
    vec3 color = use_white ? vec3(1.0, 1.0, 1.0) : vec3(0.117647, 0.117647, 0.117647);
    vec2 pixel_pos = UV * rect_size;
    float alpha = 1.0;

    // Top left corner
    if (pixel_pos.x < corner_radius && pixel_pos.y < corner_radius) {
        float dist = length(vec2(corner_radius, corner_radius) - pixel_pos);
        alpha = smoothstep(corner_radius + 0.5, corner_radius, dist);
    }
    // Top right corner
    else if (pixel_pos.x > rect_size.x - corner_radius && pixel_pos.y < corner_radius) {
        float dist = length(vec2(rect_size.x - corner_radius, corner_radius) - pixel_pos);
        alpha = smoothstep(corner_radius + 0.5, corner_radius, dist);
    }

    COLOR = vec4(color, alpha);
}