// Pixel transition shader
// Adapted from a shadertoy shader by iJ01 (https://www.shadertoy.com/view/Xl2SRd)

shader_type canvas_item;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,96.233))) * 43758.5453);
}
uniform float time: hint_range(0.0, 1.0, 0.0001) = 1.0;
uniform vec4 color: source_color;
void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
    float resolution = 5.0;
    vec2 lowresxy = vec2(
    	floor(FRAGCOORD.x / resolution),
    	floor(FRAGCOORD.y / resolution)
    );

    if(sin(time * PI / 2.0) > rand(lowresxy)){
		COLOR = color;
    }else{
		COLOR = vec4(0.0,0.0,0.0,0.0);
		// change to COLOR = vec4(0.0,0.0,0.0,1.0); to make black pixels
    }
}