--
--  Player character
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



local Class     = require("lib/30log/30log")
local Character = require("lib/character")
local P         = Character:extend("Player")



P.inspect = function (self, reach, radius)
    --
    --  Inspect the area in front of the character
    --
    local classes = {
        "Chest",
    }
    local objs  = self:query(classes, reach, radius)
    if #objs > 0 then
        for i,obj in ipairs(objs) do
            if obj.parent then
                local contents = obj.parent:interact()
                --  TODO Create an inventory buffer to indirectly add items
                if contents then self:getItem(contents) end
            end
        end
    end
end



return P



