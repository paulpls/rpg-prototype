--
--  Heads-up display
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
local Font      = require("lib/font")
local Healthbar = require("lib/healthbar")



P.init = function (self, parent)
    --
    --  Initialize the HUD
    --
    self.parent  = parent
    self.x       = 32
    self.y       = 32
    self.width   = love.graphics.getWidth() - (self.x * 2)
    self.height  = 64
    self.bgcolor = {0, 0, 0, 0.5}
    self.outline = {1, 1, 1, 0.5}
    self.icons   = love.graphics.newImage("assets/img/sprite/icons.png")
    self.quads   = {
        --  Money
        ["money"] = love.graphics.newQuad(0, 0, 16, 16, self.icons),
    }

    --  Healthbar
    self.healthbar = Healthbar:new(
        self,   -- Pass the HUD as the parent object
        3,
        3
    )

    --  Set the font
    self.font = Font:new()
end



P.update = function (self, dt)
    --
    --  Update the HUD
    --
    self.width = love.graphics.getWidth() - (self.x * 2)
    self.healthbar:set(
        self.parent.health,
        self.parent.maxHealth
    )
    self.playerCoords = {
        ["x"] = math.floor(self.parent.collider:getX() / 32),
        ["y"] = math.floor(self.parent.collider:getY() / 32)
    }
end



P.draw = function (self)
    --
    --  Draw the HUD
    --

    --  Set font
    self.font:set()

    --  Outline
    love.graphics.setColor(self.outline)
    love.graphics.rectangle(
        "line",        
        self.x - 1,
        self.y - 1,
        self.width + 1,
        self.height + 1
    )

    --  Background
    love.graphics.setColor(self.bgcolor)
    love.graphics.rectangle(
        "fill",        
        self.x,
        self.y,
        self.width,
        self.height
    )

    --  Money
    if self.parent.inventory.money then
        local x   = self.x + 24
        local y   = self.y + math.floor(self.height / 2) - 8
        local mx  = x + 24
        local my  = self.y + math.floor(self.height / 2)
        local mc  = {1, 1, 1}
        local qty = self.parent.inventory.money
        love.graphics.setColor({1, 1, 1})
        love.graphics.draw(self.icons, self.quads.money, x, y)
        if qty <= 0 then mc = {1, 0, 0} end
        self.font:print(qty, mx, my, mc)
    end

    --  Healthbar
    self.healthbar:draw()

    --  DEBUG Player coords
    if self.playerCoords then
        local x  = self.x + math.floor(self.width  / 2)
        local y  = self.y + math.floor(self.height / 2)
        local cc = {1, 0.75, 0}
        local cx = "X "..self.playerCoords.x
        local cy = "Y "..self.playerCoords.y
        self.font:print(cx.."   "..cy, x, y, cc, true)
    end
end



return P
