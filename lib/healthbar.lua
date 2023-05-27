--
--  Healthbar
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
local P     = Class("Healthbar")


--
--  Dependencies
--
local Animation = require("lib/anim8/anim8")



P.init = function (self, parent, value, max, color)
    --
    --  Initialize the healthbar
    --

    --  Parent object
    self.parent = parent
    --  Sprite size and row width
    self.size   = 16
    self.row    = 8
    --  Position and dimensions
    self.width  = math.min(self.row, max) * (self.size + 1)
    self.height = math.floor(max / value) * (self.size + 1)
    self.x      = (self.parent.x + self.parent.width) - self.width - 16
    self.y      = (self.parent.y + math.floor(self.parent.height / 2)) - math.floor(self.height / 2)
    --  Color
    self.color  = color or {1, 1, 1}
    --  Value and maximum value
    self.value  = value
    self.max    = max
    --  Animations
    self.blink  = false
    self.grid   = Animation.newGrid(
        self.size,
        self.size,
        self.parent.icons:getWidth(),
        self.parent.icons:getHeight()
    )
    self.states = {
        ["full"]  = Animation.newAnimation(self.grid("1-2", 2), 0.15),
        ["half"]  = Animation.newAnimation(self.grid("3-4", 2), 0.15),
        ["empty"] = Animation.newAnimation(self.grid("5-6", 2), 0.15)
    }
    for _,s in pairs(self.states) do s:pauseAtStart() end
    self:resetTimer()
end



P.set = function (self, value, max)
    --
    --  Set the healthbar value and maximum value
    --
    if value < self.value then
        self:resetTimer()
        self.blink = true
    elseif value > self.value then
        self.blink = false
    end
    --  Blink repeatedly when at low health
    if value <= 1 then self.blink = true end
    self.value = value or self.value
    self.max   = max   or self.max
end



P.resetTimer = function (self, t)
    --
    --  Reset the timer to the provided time
    --
    self.timer = t or 0.6
end



P.update = function (self, dt)
    --
    --  Update the healthbar
    --
    if self.blink and self.timer > 0 then
        for _,s in pairs(self.states) do
            s:resume()
            s:update(dt)
        end
        self.timer = self.timer - dt
    else
        for _,s in pairs(self.states) do s:pauseAtStart() end
        self:resetTimer()
        if self.value > 1 then self.blink = false end
    end
end



P.draw = function (self)
    --
    --  Draw the healthbar
    --
    local value = self.value
    local max   = self.max
    local row   = self.row
    local size  = self.size + 1
    local color = self.color
    love.graphics.setColor(color)
    --  Count total health
    local count = 0
    --  Draw the healthbar
    while count < max do
        local hx      = size * ((count % row) - 1)
        local hy      = size * math.floor(count / row)
        local state   = self.states.empty
        local health  = value - count
        if health > 0 then
            if health == 0.5 then
                state = self.states.half
            else
                state = self.states.full
            end
        end
        state:draw(
            self.parent.icons,
            self.x + hx,
            self.y + hy
        )
        count = count + 1
    end
end



return P



