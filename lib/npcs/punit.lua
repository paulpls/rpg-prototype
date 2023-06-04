--
--  Create a new NPC: Punit
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



local Class = require("lib/30log/30log")
local NPC   = require("lib/npc")
local P     = NPC:extend("CustomNPC")



--
--  Dependencies
--
local C10n = require("lib/c10n")



P.interact = function (self, player)
    --
    --  Interact with the NPC
    --
    local id = "hello"
    if player.inventory.money >= 50 and self.inventory.key then 
        if self.inventory.key > 0 then
            id = "buy"
        end
    end
    local convo = C10n:new(id, self, player)
    self:talk(convo, player)
end



P.doAction = function (self, player, id)
    --
    --  Perform an action based on its id
    --
    if id == "buy_key_50c" then
        self:giveItem(player, "key", 1, 50)
    end
end



return P



