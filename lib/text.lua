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
        self.maxL   = options.maxL
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
    self.maxL   = self.maxL   or 3
    self.color  = self.color  or {1, 1, 1}
    self.tick   = self.tick   or false
    self.scroll = self.scroll or false
    self.delay  = self.delay  or 0.04
    --  Refresh everything
    self:reload()
end



P.reload = function (self, line)
    --
    --  Reset timer, output buffer, etc
    --
    self.timer  = 0
    self.line   = line or 1
    --  Set up line buffer for scrolling
    self.lines  = {}
    local line  = self.line
    local words = split(self.body)
    local x     = self:getWidth(words[1])
    for i, word in ipairs(words) do
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
            self.lines[line]  = word
            self.buffer[line] = ""
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
    --  TODO Wait for user input before scrolling
    --
    local body  = self.body
    if self.scroll then body = self.lines[self.line] end
    if not self:done() then
        --  Decrement timer
        self.timer = self.timer - dt
        if self.timer <= 0 then
            --  Increase buffer length by 1 char
            local len              = #self.buffer[self.line] + 1
            self.buffer[self.line] = self.buffer[self.line] .. body:sub(len, len)
            --  Offset the timer
            self.timer = self.timer + self.delay
        end
    else
        --  Increase buffer line number
        if self.line < #self.lines then self.line = self.line + 1 end
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
    --  Print each line in the buffer
    if self.scroll then
        --  Line height
        local h = self:getHeight() + gap
        --  Scroll the output
        local start = math.max(1, (self.line + 1) - self.maxL)
        local stop  = math.min(start + self.maxL, #self.buffer)
        for line = start, stop do
            --  Current (local) line number
            local ln = line - start
            --  Get current line
            local text = self.buffer[line]:upper()
            --  Calculate line height, y offset and text coordinates
            local oy  = h * ln
            local x,y = self.x, self.y + oy
            self.font:print(text, x, y, self.color)
        end
    else
        local text = body:upper()
        local x,y  = self.x, self.y
        self.font:print(text, x, y, self.color)
    end
end



return P



