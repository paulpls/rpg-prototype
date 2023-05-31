--
--  Text wrapper
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
local P     = Class("Text")



--
--  Dependencies
--
local Font = require("lib/font")



P.init = function (self, body, font, x, y, w, h, color, tick)
    --
    --  Instantiate a new text object
    --
    self.body   = body  or ""
    self.body   = string.upper(self.body)
    self.font   = font  or Font:new()
    self.x      = x     or 0
    self.y      = y     or 0
    self.w      = w     or self:getWidth()
    self.h      = h     or self:getHeight()
    self.color  = color or {1, 1, 1}
    self.tick   = tick  or false
    self.ticker = ""
    self.timer  = 0
    self.delay  = 0.25  
    self.done   = function (self) return self.ticker == self.body end
--    print("----")
--    print("body:   "..self.body)
--    print("ticker: "..self.ticker)
--    print("x,y:    "..self.x..","..self.y)
--    print("w,h:    "..self.w..","..self.h)
--    print("----")
end



P.getWidth = function (self)
    --
    --  Get the current width of the text to be displayed
    --
    local text = self.body
    if self.tick then text = ticker end
    return self.font:getWidth(text)
end



P.getHeight = function (self)
    --
    --  Get the current height of the text to be displayed
    --
    local text = self.body
    if self.tick then text = ticker end
    return self.font.h
end



P.update = function (self, dt)
    --
    --  Update the text and animate if needed
    --
    if not self:done() then
        --  Decrement timer
        self.timer = self.timer - dt
        if self.timer <= 0 then
            --  Increase ticker length by 1
            local len = #self.ticker + 1
            self.ticker = self.ticker .. self.body:sub(len, len)
            --  Offset the timer
            self.timer = self.timer + self.delay
        end
    else
        --  Reset timer
        self.timer = 0
    end
end



P.draw = function (self)
    --
    --  Draw the text (or ticker value)
    --  TODO Animate text per character
    --  TODO Keep track of buffer height/width and clamp as necessary
    --
    local body = self.body
    if self.tick then body = self.ticker end
    --  Print the text
    love.graphics.setColor(self.color)
    self.font:set()
    love.graphics.print(body, self.x, self.y)
end



return P



