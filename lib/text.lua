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



local split = function (str, d)
    --
    --  Split `str` by `s` and return a table of results
    --
    local output    = {}
    local delimiter = d or "%s"
    local pattern   = "([^"..delimiter.."]+)"
    for s in str:gmatch(pattern) do table.insert(output, s) end
    return output
end



P.init = function (self, body, options)
    --
    --  Instantiate a new text object
    --
    self.body = body or ""
    --  Readout buffer
    self.line              = 1
    self.buffer            = {}
    self.buffer[self.line] = self.body:sub(1, 1)
    --  Set options if present
    if options then
        self.font   = options.font
        self.x      = options.x
        self.y      = options.y
        self.w      = options.w
        self.h      = options.h
        self.maxW   = options.maxW
        self.maxH   = options.maxH
        self.color  = options.color
        self.tick   = options.tick
        self.scroll = options.scroll
        self.delay  = options.delay
    end
    --  Set defaults for parameters not defined in options
    self.font   = self.font   or Font:new()
    self.x      = self.x      or 0
    self.y      = self.y      or 0
    self.w      = self.w      or self:getWidth()
    self.h      = self.h      or self:getHeight()
    self.maxW   = self.maxW   or self.w
    self.maxH   = self.maxH   or self.h
    self.color  = self.color  or {1, 1, 1}
    self.tick   = self.tick   or false
    self.scroll = self.scroll or false
    self.delay  = self.delay  or 0.025
    self.timer  = 0
    --  Set up line buffer for scrolling
    self.lines  = {}
    local line  = self.line
    local words = split(self.body)
    local x     = self:getWidth(words[1])
    for i,word in ipairs(words) do
        local len = self:getWidth(word)
        --  Add 1 char worth of space after the first word
        if i > 1 then len = len + self.font.w end
        if x + len > self.maxW then 
            line = line + 1 
            x    = self:getWidth(word)
        else
            x = x + len
        end
        if not self.lines[line] then
            self.lines[line] = word
        else
            self.lines[line] = self.lines[line].." "..word
        end
    end
end



P.done = function (self)
    local body = self.body
    if self.scroll then body = self.lines[self.line] end
    return not self.tick or self.buffer[self.line] == body
end



P.getWidth = function (self, word)
    --
    --  Get the current width of the text to be displayed
    --
    if not word then word = self.body end
    return self.font:getWidth(word)
end



P.getHeight = function (self)
    --
    --  Get the current height of the text to be displayed
    --
    return self.font.h
end



P.update = function (self, dt)
    --
    --  Update and animate the text
    --  FIXME Only display lines that fit and scroll appropriately so as to not overflow the box
    --
    local body = self.body
    if self.scroll then body = self.lines[self.line] end
    if not self:done() then
        --  Decrement timer
        self.timer = self.timer - dt
        if self.timer <= 0 then
            --  Increase buffer length by 1
            local len              = #self.buffer[self.line] + 1
            self.buffer[self.line] = self.buffer[self.line] .. body:sub(len, len)
            --  Offset the timer
            self.timer = self.timer + self.delay
        end
    else
        --  Increase line number and reload buffer
        if self.line < #self.lines then
            self.line              = self.line + 1
            self.buffer[self.line] = ""
        end
        --  Reset timer
        self.timer = 0
    end
end



P.draw = function (self)
    --
    --  Draw the text (or ticker value)
    --
    self.font:set()
    --  Get body or ticker text
    local body = self.body
    local gap  = 8
    if self.tick then body = self.ticker end
    --  DEBUG Draw bounding boxes
    --local ox,oy = self.x, self.y
    --local ow,oh = self.maxW, self.maxH
    --love.graphics.setColor({0,1,1})
    --love.graphics.rectangle("line", ox, oy, ow, oh)
    --
    --  Print each line in the buffer
    if self.scroll then
        for line,text in pairs(self.buffer) do
            local text = text:upper()
            local x,y = self.x, self.y + ((line - 1) * ((self:getHeight() + gap)))
            --  DEBUG Draw bounding boxes for text
            --local w,h = self:getWidth(text), self:getHeight()
            --love.graphics.setColor({1,0,0})
            --love.graphics.rectangle("line", x, y, w, h)
            --
            self.font:print(text, x, y, self.color)
        end
    else
        local text = body:upper()
        local x,y  = self.x, self.y
         --  DEBUG Draw bounding boxes for text
        --local w,h = self:getWidth(text), self:getHeight()
        --love.graphics.setColor({1,0,0})
        --love.graphics.rectangle("line", x, y, w, h)
        --
        self.font:print(text, x, y, self.color)
    end
end



return P



