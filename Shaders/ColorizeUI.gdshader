shader_type canvas_item;

uniform vec4 color: source_color;

void fragment(){
  COLOR = texture(TEXTURE, UV); //read from texture
  COLOR.rgb = color.rgb; //set blue channel to 1.0
}
