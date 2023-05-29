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
local Dialog = require("lib/dialog")



P.interact = function (self, char)
    --
    --  Interact with the NPC
    --
    self:talk(char)
end



P.talk = function (self, char, context)
    --
    --  Add some dialogs for player interaction
    --
    self:face(char, true)
    local context = context or "hello"
    if not self.dialog[context] then context = "hello" end
    local random  = math.random(1, #self.dialog[context])
    local msg     = self.dialog[context][random]
    --  Create a new dialog and push it to the global stack
    Dialog.push(
        Dialog:new(
            string.upper(msg)
        )
    )
end



return P



