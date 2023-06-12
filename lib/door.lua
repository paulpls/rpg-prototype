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



P.init = function (self, physics, x, y, locked, dest)
    --
    --  Initialize a new door
    --
    local w,h   = 32, 64
    self.x      = x or 0 
    self.y      = y or 0
    self.locked = locked or false
    self.dest   = dest
    self.opened = false
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
    self.collider:setObject(self)
end



P.open = function (self)
    --
    --  Open the door and destroy the collider
    --
    self.opened = true
    self.collider:setCollisionClass("OpenDoor")
end



P.unlock = function (self)
    --
    --  Unlock the door
    --
    if self.locked then self.locked = false end
    self:open()
end



P.interact = function (self, char)
    --
    --  Unlock or open the door
    --
    local msg = nil
    if not self.locked then
        --  Open the door
        self:open()
    else
        --  Door is locked; check for keys
        if char:delItem("key") then
            --  Unlock the door
            self:unlock()
        else
            --  Alert the player that the door can be unlocked
            msg = "This door is locked but there might be a key somewhere"
        end
    end
    if msg then Dialog.push(Dialog:new(msg)) end
end



P.send = function (self)
    --
    --  Send the player to the door's destination
    --
    if self.dest then
        world:load("data/world/"..self.dest.world, self.dest.x, self.dest.y)
    end
end



P.update = function (self, dt)
    --
    --  Update the door
    --
    if self.locked then
        self.quad = P.quads.locked
    else
        if self.opened then
            self.quad = P.quads.open
        else
            self.quad = P.quads.closed
        end
    end
    --  Detect entry
    if self.collider.collision_class == "OpenDoor" and self.collider:exit("Player") then
        self:send()
    end
end



P.draw = function (self)
    --
    --  Draw the door
    --
    love.graphics.draw(
        P.img,
        self.quad,
        self.x,
        self.y
    )
end



return P



