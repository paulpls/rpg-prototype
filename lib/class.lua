--
--  Class factory
--
local classMetatable = {}



classMetatable.__index = function (self, key)
    --
    --  Set metatable
    --
    return self.__baseclass[key]
end
Class = setmetatable({__baseclass={}}, classMetatable)



Class.new = function (self, ...)
    --
    --  Factory
    --
    local c       = {}
    c.__baseclass = self
    setmetatable(c, getmetatable(self))
    if c.init then c:init(...) end
    return c
end



