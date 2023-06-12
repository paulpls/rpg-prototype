--
--  Chest model
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
local P     = Class("Chest")

P.img       = love.graphics.newImage("assets/img/sprite/chest.png")
P.quads     = {
    ["closed"]   = love.graphics.newQuad(0,  0, 32, 32, P.img),
    ["open"]     = love.graphics.newQuad(32, 0, 32, 32, P.img),
    ["locked"]   = love.graphics.newQuad(64, 0, 32, 32, P.img),
    ["unlocked"] = love.graphics.newQuad(96, 0, 32, 32, P.img),
}
P.img:setFilter("nearest", "nearest")



--
--  Dependencies
--
local Dialog = require("lib/dialog")



P.init = function (self, physics, x, y, contents, locked)
    --
    --  Initialize a new chest
    --
    self.x        = x or 0 
    self.y        = y or 0
    self.contents = contents
    self.locked   = locked
    self.opened   = false
    self.quad     = P.quads.closed
    self.collider = physics:newRectangleCollider(
        self.x + 4,
        self.y + 8,
        24,
        20
    )
    self.collider:setCollisionClass("Chest")
    self.collider:setType("static")
    self.collider:setObject(self)
end



P.open = function (self)
    --
    --  Open the chest
    --
    if not self.opened then self.opened = true end
    local name = self.contents.name
    local qty  = self.contents.qty
    local msg  = "You got "..qty.." "..name.."!"
    return msg
end



P.unlock = function (self)
    --
    --  Unlock the chest
    --
    if self.locked then self.locked = false end
    return self:open()
end



P.interact = function (self, player)
    --
    --  Open the chest and return contents
    --
    local msg  = nil
    if self.locked == nil and not self.opened then
        msg = self:open()
        player:getItem(
            self.contents.item,
            self.contents.qty
        )
    elseif self.locked then
        --  Check for keys in inventory and remove 1
        if player:delItem("key") then
            msg = self:unlock()
            player:getItem(
                self.contents.item,
                self.contents.qty
            )
        else
            msg = "This chest is locked"
        end
    end
    if msg then Dialog.push(Dialog:new(msg)) end
end



P.update = function (self, dt)
    --
    --  Update the chest
    --
    if self.locked then
        self.quad = P.quads.locked
    elseif self.locked == false then
        self.quad = P.quads.unlocked
    else
        if self.opened then
            self.quad = P.quads.open
        else
            self.quad = P.quads.closed
        end
    end
end



P.draw = function (self)
    --
    --  Draw the chest
    --
    love.graphics.draw(
        P.img,
        self.quad,
        self.x,
        self.y
    )
end



return P



