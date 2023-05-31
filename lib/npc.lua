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
currentConvo    = nil



--
--  Dependencies
--
local Dialog = require("lib/dialog")
local C10n   = require("lib/c10n")



P.interact = function (self, player)
    --
    --  Interact with the NPC
    --  TODO Buy an item for 50c; add actions to convo behavior
    --
    local id = "hello"
    if player.inventory.money >= 50 then id = "buy" end
    local convo = C10n:new(id, self, player)
    self:talk(convo, player)
end



P.talk = function (self, convo, player)
    --
    --  Add some dialogs for player interaction
    --

    --  Update current conversation
    currentConvo = convo

    --  FIXME Face towards the player (opposite dir to player for now)
    self:face(player, true)

    --  Follow convo tree, create dialogs and push the global stack
    local msgs    = convo:getMsgs()
    local header  = {
         ["text"] = self.name,
         ["img" ] = self.portrait
    }

    --  Load options
    local options = convo.options
    for _,msg in ipairs(msgs) do
        local d = Dialog:new(
            msg,
            header,
            options
        )
        Dialog.push(d)
    end
    
    --  Stop or load next conversation
    if convo.stop then
        currentConvo.kill()
    elseif convo.nextid then
        local convo = C10n:new(convo.nextid, self, player)
        self:talk(convo, player)
    end
end



return P



