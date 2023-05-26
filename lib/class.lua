--
--  Class factory
--
--[[

    Copyright (C) 2023 Paul Clayberg
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
]]



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



