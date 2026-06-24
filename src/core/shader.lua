shader  =  [[
    extern vec3 colors[8];

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { 
        vec4 tex_color = Texel(texture, texture_coords);
        float index = tex_color.r-1; //0-indexed, probably...
        vec4 new_color = vec4(colors[int(index)],tex_color.a);
        return new_color;
    }
    ]]

return shader 

