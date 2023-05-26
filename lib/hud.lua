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
local Font = require("lib/font")



P.init = function (self)
    --
    --  Initialize the HUD
    --
    self.x       = 32
    self.y       = 32
    self.width   = love.graphics.getWidth() - (self.x * 2)
    self.height  = 64
    self.bgcolor = {0, 0, 0, 0.5}
    self.outline = {1, 1, 1, 0.5}
    self.content = {}
    self.icons   = love.graphics.newImage("assets/img/sprite/icons.png")
    self.quads   = {
        --  Money
        ["money"]             = love.graphics.newQuad(0,   0,   16,  16,  self.icons),
        --  Lifebar
        ["heart_full"]        = love.graphics.newQuad(0,   16,  16,  16,  self.icons),
        ["heart_full_blink"]  = love.graphics.newQuad(16,  16,  16,  16,  self.icons),
        ["heart_half"]        = love.graphics.newQuad(32,  16,  16,  16,  self.icons),
        ["heart_half_blink"]  = love.graphics.newQuad(48,  16,  16,  16,  self.icons),
        ["heart_empty"]       = love.graphics.newQuad(64,  16,  16,  16,  self.icons),
        ["heart_empty_blink"] = love.graphics.newQuad(80,  16,  16,  16,  self.icons),
    }

    --  Set the font
    self.font = Font:new()
end



P.update = function (self, dt)
    --
    --  Update the HUD
    --
    self.width = love.graphics.getWidth() - (self.x * 2)
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
    if self.content.money then
        local x   = self.x + 24
        local y   = self.y + math.floor(self.height / 2) - 8
        local mx  = x + 24
        local my  = self.y + math.floor(self.height / 2)
        local mc  = {1, 1, 1}
        local qty = self.content.money
        love.graphics.setColor({1, 1, 1})
        love.graphics.draw(self.icons, self.quads.money, x, y)
        if qty <= 0 then mc = {1, 0, 0} end
        self.font:print(qty, mx, my, mc)
    end

    --  Player healthbar
    if self.content.health then
        local qty = self.content.health
        local max = self.content.maxHealth or self.content.health
        local row = 8
        local hbw = 17 * row
        local hbh = 17 * (math.floor(qty / row) % row)
        local x   = self.x + self.width - hbw - 24
        local y   = self.y + math.floor(self.height / 2) - math.floor(hbh / 2) - 8
        local hbc = {1, 1, 1}
        love.graphics.setColor(hbc)
        --  Count total health
        local count = 0
        --  Draw the healthbar
        while count < max do
            local hx     = x + ((17 * math.floor(count)) % hbw)
            local hy     = y
            local quad   = self.quads.heart_empty
            local health = qty - count
            if health > 0 then
                if health == 0.5 then
                    quad = self.quads.heart_half
                else
                    quad = self.quads.heart_full
                end
            end
            love.graphics.draw(self.icons, quad, hx, hy)
            if health >= 1 then
                count = count + 1
            else
                count = count + 0.5
            end
        end
    end

    --  DEBUG Player coords
    if self.content.coords then
        local x  = self.x + math.floor(self.width  / 2)
        local y  = self.y + math.floor(self.height / 2)
        local cc = {1, 0.75, 0}
        local cx = "X "..self.content.coords.x
        local cy = "Y "..self.content.coords.y
        self.font:print(cx.."   "..cy, x, y, cc, true)
    end
end



return P
