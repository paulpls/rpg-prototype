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
    ["closed"] = love.graphics.newQuad(0,  0, 32, 32, P.img),
    ["open"]   = love.graphics.newQuad(32, 0, 32, 32, P.img)
}
P.img:setFilter("nearest", "nearest")



--
--  Dependencies
--
local Dialog = require("lib/dialog")



P.init = function (self, physics, x, y, contents)
    --
    --  Initialize a new chest
    --
    self.x        = x or 0 
    self.y        = y or 0
    self.contents = contents
    self.open     = false
    self.quad     = P.quads.closed
    self.collider = physics:newRectangleCollider(
        self.x + 4,
        self.y + 8,
        24,
        20
    )
    self.collider:setCollisionClass("Chest")
    self.collider:setType("static")
    self.collider.parent = self
end



P.interact = function (self, player)
    --
    --  Open the chest and return contents
    --
    if not self.open then
        self.open  = true
        local name = self.contents.name
        local qty  = self.contents.qty
        --  Create a new dialog and push it to the global stack
        local msg  = "You found "..qty.." "..name.."!"
        Dialog.push(Dialog:new(msg))
        --  Give item to player
        local item = self.contents.item
        local qty  = self.contents.qty
        player:getItem(item, qty)
    end
end



P.update = function (self, dt)
    --
    --  Update the chest
    --
    if self.open then
        self.quad = P.quads.open
    else
        self.quad = P.quads.closed
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



