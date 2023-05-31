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



P.init = function (self, body, options)
    --
    --  Instantiate a new text object
    --
    self.body   = body or ""
    self.ticker = self.body:sub(1,1)
    self.buffer = ""
    --  Set options if present
    if options then
        self.font  = options.font
        self.x     = options.x
        self.y     = options.y
        self.w     = options.w
        self.h     = options.h
        self.maxW  = options.maxW
        self.maxH  = options.maxH
        self.color = options.color
        self.tick  = options.tick
        self.delay = options.delay
    end
    --  Set defaults
    self.font   = self.font  or Font:new()
    self.x      = self.x     or 0
    self.y      = self.y     or 0
    self.w      = self.w     or self:getWidth()
    self.h      = self.h     or self:getHeight()
    self.maxW   = self.maxW  or self.w
    self.maxH   = self.maxH  or self.h
    self.color  = self.color or {1, 1, 1}
    self.delay  = self.delay or 0.025
    self.tick   = self.tick  or false
    self.timer  = 0
    self.done   = function (self) return not self.tick or self.ticker == self.body end
end



P.getWidth = function (self)
    --
    --  Get the current width of the text to be displayed
    --
    local text = self.body
    if self.tick then text = self.ticker end
    return self.font:getWidth(text)
end



P.getHeight = function (self)
    --
    --  Get the current height of the text to be displayed
    --
    local text = self.body
    if self.tick then text = self.ticker end
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
            local len   = #self.ticker + 1
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
    --  FIXME Text is not contained by box; use a buffer instead of the whole string
    --
    local body = self.body
    if self.tick then body = self.ticker end
    --  Print the text
    self.font:set()
    love.graphics.setColor(self.color)
    love.graphics.print(body:upper(), self.x, self.y)
end



return P



