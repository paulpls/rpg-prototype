--
--  Non player character prototype
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
local P         = Character:extend("NPC")



--
--  Dependencies
--
local Dialog       = require("lib/dialog")
local Conversation = require("lib/conversation")



P.interact = function (self, char)
    --
    --  Interact with the NPC
    --  TODO Buy an item for 50c; add actions to convo behavior
    --
    local id = "hello"
    if char.inventory.money >= 50 then id = "buy" end
    self:talk(char, id)
end



P.talk = function (self, char, id)
    --
    --  Add some dialogs for player interaction
    --

    --  Face the player
    self:face(char, true)

    --  Setup conversation
    local id    = id or "hello"
    local convo = Conversation:new(id, self, char)
    local msgs  = convo:getMsgs()

    --  Create a new dialog and push it to the global stack
    for _,m in ipairs(msgs) do
        local d = Dialog:new(
            string.upper(m),
            {
                ["text"] = string.upper(self.name),
            }
        )
        Dialog.push(d)
    end

end



return P



