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
    --  Inspect the area in front of the player
    --
    local reach  = reach  or 1
    local radius = radius or 10

end



P.getItem = function (self, data)
    --
    --  Add items to the player's inventory
    --
    local name = data.name
    local qty  = data.qty or 1
    if self.inventory[name] then
        self.inventory[name] = self.inventory[name] + qty
    else
        self.inventory[name] = qty
    end
end



P.heal = function (self, n)
    --
    --  Heal the player by `n` points; fully heals if no value given
    --
    if n then
        local health = self.health + n
        self.health  = math.min(health, self.maxHealth)
    else
        self.health  = self.maxHealth
    end
end



P.damage = function (self, n)
    --
    --  Damage the player by `n` points
    --
    local health = self.health - n
    self.health  = math.max(health, 0)
end



return P



