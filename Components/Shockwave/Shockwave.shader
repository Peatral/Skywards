shader_type canvas_item;

uniform vec2 center = vec2(0); // Mouse position
uniform float time = 0; // effect elapsed time
uniform vec3 shockParams = vec3(0); // 10.0, 0.8, 0.1

void fragment() { 
	vec2 texCoord = SCREEN_UV;
	float distance = distance(SCREEN_UV, center);
	if ( (distance <= (time + shockParams.z)) && (distance >= (time - shockParams.z)) ) {
		float diff = (distance - time); 
		float powDiff = 1.0 - pow(abs(diff*shockParams.x), shockParams.y); 
		float diffTime = diff  * powDiff; 
		vec2 diffUV = normalize(SCREEN_UV - center); 
		texCoord = SCREEN_UV + (diffUV * diffTime);
	} 
	COLOR = texture(SCREEN_TEXTURE, texCoord);
}
