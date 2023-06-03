--
--  Door model
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
local P     = Class("Door")

P.img       = love.graphics.newImage("assets/img/sprite/door.png")
P.quads     = {
    ["locked"] = love.graphics.newQuad(0,  0, 32, 64, P.img),
    ["closed"] = love.graphics.newQuad(32, 0, 32, 64, P.img),
    ["open"]   = love.graphics.newQuad(64, 0, 32, 64, P.img)
}
P.img:setFilter("nearest", "nearest")



--
--  Dependencies
--
local Dialog = require("lib/dialog")



P.init = function (self, physics, x, y, locked)
    --
    --  Initialize a new door
    --
    local w,h     = 32, 64
    self.x        = x or 0 
    self.y        = y or 0
    self.locked   = locked or false
    self.open     = false
    if self.locked then
        self.quad = P.quads.closed
    else
        self.quad = P.quads.closed
    end
    --  Physics
    self.collider = physics:newRectangleCollider(
        self.x,
        self.y + h - 1,
        w,
        1
    )
    self.collider:setCollisionClass("Door")
    self.collider:setType("static")
    self.collider.parent = self
end



P.interact = function (self, char)
    --
    --  Unlock or open the door
    --
    if not self.locked then
        if not self.open then
            self.open  = true
            self.collider:destroy()
        end
    else
        --  Create a new dialog and push it to the global stack
        local msg  = "This door is locked but there might be a key somewhere"
        Dialog.push(Dialog:new(msg))
    end
end



P.update = function (self, dt)
    --
    --  Update the chest
    --
    if self.locked then
        self.quad = P.quads.locked
    else
        if self.open then
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



