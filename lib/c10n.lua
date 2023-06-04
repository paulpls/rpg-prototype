--
--  Conversation mechanics
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
local P     = Class("Conversation")



--
--  Dependencies
--
local Dialog = require("lib/dialog")



P.init = function (self, id, npc, player)
    --
    --  Initialize a new conversation
    --
    self.id     = id
    self.npc    = npc
    self.player = player
    self:load()
end



P.load = function (self, id)
    --
    --  Load message from NPC conversation data
    --
    self.id = id or self.id
    assert(
        self.npc.conversation[self.id],
        "Invalid conversation id "..self.npc.name.." > "..tostring(self.id)
    )
    --  Get data
    local data   = self.npc.conversation[self.id]
    self.msgs    = data.msgs
    self.nextid  = data.nextid
    self.previd  = data.previd or self.id
    self.options = data.options
    self.actions = data.actions
    self.stop    = data.stop or false
end



P.getMsgs = function (self)
    --
    --  Get random messages from the current set
    --
    local out  = {}
    local msgs = self.msgs
    for i,_ in ipairs(msgs) do
        local r   = math.random(1, #msgs[i])
        local msg = msgs[i][r]
        table.insert(out, msg)
    end
    return out
end



P.kill = function ()
    --
    --  Kill the conversation immediately
    --
    currentConvo = nil
end



P.update = function (self, dt)
    --
    --  Update the Conversation
    --
    --  Fetch dialogs
    if not currentDialog then
        if #dialogs > 0 then currentDialog = Dialog:pop() end
    else
        currentDialog:update(dt)
    end
end



P.draw = function (self)
    --
    --  Draw the Conversation
    --
    if currentDialog then currentDialog:draw() end
end



return P



