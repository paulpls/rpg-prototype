--
--  Character model
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



local P = Class:new()



--
--  Dependencies
--
local Animation = require("lib/anim8/anim8")



P.init = function (self, path, world, x, y)
    --
    --  Initialize the character
    --

    --  Load data from file
    local data = assert(
        require(path),
        "Unable to load character data: "..tostring(path)
    )

    --  Configure image and grid properties
    self.img  = love.graphics.newImage(data.path)
    self.grid = Animation.newGrid(
        data.width,
        data.height,
        self.img:getWidth(),
        self.img:getHeight()
    )

    --  Position
    self.x = x or data.x
    self.y = y or data.y

    --  Offset
    self.ox = data.ox or 0
    self.oy = data.oy or 0


    -- Speed
    self.vx = data.vx or 50
    self.vy = data.vy or 50

    --  Animations
    self.action  = "default"
    self.dir     = "down"
    self.facing  = data.facing
    self.actions = data.actions
    self.state   = nil
    self.states  = {}
    for f,row in pairs(self.facing) do
        for a,info in pairs(self.actions) do
            local name   = a.."_"..f
            self.states[name] = Animation.newAnimation(
                self.grid(info.frames, row),
                info.delay
            )
        end
    end

    --  Define collider
    local c = data.colliderInfo
    self.collider = world:newBSGRectangleCollider(
        c.x,
        c.y,
        c.width,
        c.height,
        c.cutoff
    )
    self.collider:setFixedRotation(true)

    --  Reach distance, defaults to average of collider dimensions
    local reach = math.floor(((c.width + c.height) / 2) * (3/4))
    self.reach  = data.reach or reach

    --  Inventory
    self.inventory = {
        ["money"] = 0,
    }

end



P.getState = function (self)
    --
    --  Get current animation state
    --
    if self.state then
        return self.state
    else
        local name = self.action..self.dir
        return self.states[name]
    end
end



P.setState = function (self)
    --
    --  Update the current animation state
    --
    local name  = self.action.."_"..self.dir
    self.state  = self.states[name]
end



P.update = function (self, dt)
    --
    --  Update the character sprite and animation
    --
    self:getState():update(dt)
    --  Reset some animations if not moving
    if self.action ~= "walk" then
        for f,_ in pairs(self.facing) do
            self.states["walk_"..f]:gotoFrame(1)
        end
    end
end



P.move = function (self, x, y)
    --
    --  Move the character by a specified amount
    --
    local dx = self.x + (self.vx * x)
    local dy = self.y + (self.vy * y)
    self:position(dx, dy)
end



P.position = function (self, x, y)
    --
    --  Position the player at the specified coordinates
    --
    if x then self.x = x + self.ox end
    if y then self.y = y + self.oy end
end



P.inspect = function (self, reach, radius)
    --
    --  Inspect the area in front of the player
    --
    local reach  = reach  or 1
    local radius = radius or 10

end



P.getItem = function (self, data)
    --
    --  Add items to the player's inventory
    --
    local name = data.name
    local qty  = data.qty or 1
    self.inventory[name] = self.inventory[name] + qty
end



P.draw = function (self)
    --
    --  Draw the character
    --
    self:getState():draw(
        self.img, 
        self.x,
        self.y
    )
end



return P



