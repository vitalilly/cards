shader  =  [[
    extern vec3 colors[8];

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { 
        vec4 tex_color = Texel(texture, texture_coords); //inspect colour of each pixel as it's rendered
        int index = int(tex_color.r*255)-1; // index palette based on red channel of the pixel, shifted -1 to be 0-indexed probably...
        vec4 new_color = vec4(tex_color); 
        if (index < 8) {
            new_color = vec4(colors[index],tex_color.a); // find color from palette
        }
        return new_color; //RETURN THE COLOR
    }
    ]]

return shader 

