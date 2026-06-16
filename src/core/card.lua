local card = {
    image = "",
    textDescription = ""
}

function card:new(o) --Intitialise an instance of the card class
    o = o or {} --Give a blank table if no object is given
    setmetatable(o,self)
    self.__index = self
    return o
end



