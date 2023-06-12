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
local Door  = require("lib/door")
local P     = Door:extend("Exit")

P.img       = love.graphics.newImage("assets/img/sprite/exit.png")
P.img:setFilter("nearest", "nearest")



P.init = function (self, physics, x, y, dest)
    --
    --  Initialize a new exit
    --
    local w,h   = 32, 32
    self.x      = x or 0 
    self.y      = y or 0
    self.dest   = dest
    --  Physics
    self.collider = physics:newRectangleCollider(
        self.x,
        self.y + h - 1,
        w,
        1
    )
    self.collider:setCollisionClass("OpenDoor")
    self.collider:setType("static")
    self.collider:setObject(self)
end



P.open = function (self)
    --
    --  Override
    --
    return
end



P.unlock = function (self)
    --
    --  Override
    --
    return
end



P.interact = function (self, char)
    --
    --  Override
    --
    return
end



P.update = function (self, dt)
    --
    --  Detect entry
    --
    if self.collider:enter("Player") then
        self:send()
    end
end



P.draw = function (self)
    --
    --  Draw the exit
    --
    love.graphics.draw(
        P.img,
        self.x,
        self.y
    )
end



return P



