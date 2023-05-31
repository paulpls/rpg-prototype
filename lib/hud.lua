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



local Class = require("lib/30log/30log")
local P     = Class("HUD")



--
--  Dependencies
--
local Text      = require("lib/text")
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
    self.bgcolor = {0, 0, 0, 0.75}
    self.outline = {1, 1, 1, 0.75}
    self.icons   = love.graphics.newImage("assets/img/sprite/icons.png")
    self.quads   = {
        --  Money
        ["money"] = love.graphics.newQuad(0, 0, 16, 16, self.icons),
    }

    --  Healthbar
    self.healthbar = Healthbar:new(
        self,   -- Pass the HUD as the parent object
        parent.health,
        parent.maxHealth
    )

end



P.update = function (self, dt)
    --
    --  Update the HUD
    --

    --  Responsive width
    self.width = love.graphics.getWidth() - (self.x * 2)

    --  Healthbar
    self.healthbar:set(
        self.parent.health,
        self.parent.maxHealth
    )
    self.healthbar:update(dt)
    
    --  DEBUG Player coordinates
    self.coords = {
        ["x"] = math.floor(self.parent.collider:getX() / 32),
        ["y"] = math.floor(self.parent.collider:getY() / 32)
    }

    --  Create text wrappers
    local money = nil
    if self.parent.inventory.money then
        money = Text:new(
            tostring(self.parent.inventory.money)
        )
    end
    local coords = Text:new(
        "X "..tostring(self.coords.x).."   ".."Y "..tostring(self.coords.y)
    )
    self.texts = {
        ["money"]  = money,
        ["coords"] = coords,
    }
end



P.draw = function (self)
    --
    --  Draw the HUD
    --

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
    if self.texts.money then
        local text = self.texts.money
        local x    = self.x + 24
        local y    = self.y + math.floor(self.height / 2) - 8
        text.x     = x + 24
        text.y     = self.y + math.floor(self.height / 2) - math.floor(text.h / 2)
        text.color = {1, 1, 1}
        --  Draw icon
        love.graphics.setColor({1, 1, 1})
        love.graphics.draw(self.icons, self.quads.money, x, y)
        --  Draw text label
        if self.parent.inventory.money <= 0 then text.color = {1, 0, 0} end
        text:draw()
    end

    --  Healthbar
    self.healthbar:draw()

    --  DEBUG Player coords
    if self.texts.coords then
        local text = self.texts.coords
        text.x     = self.x + math.floor(self.width  / 2) - math.floor(text.w / 2)
        text.y     = self.y + math.floor(self.height / 2) - math.floor(text.h / 2)
        text.color = {1, 0.75, 0}
        text:draw()
    end
end



return P



