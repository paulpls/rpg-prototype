--
--  Font management
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
local P     = Class("Font")

P._path     = "assets/font/pixel.png"
P._glyphs   = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
P._w        = 16   --  Character width
P._h        = 20   --  Character height
P._k        = 2    --  Kerning



P.init = function (self, path, glyphs, w, h, k)
    --
    --  Initialize font
    --
    self.path   = path   or P._path
    self.glyphs = glyphs or P._glyphs
    self.w      = w      or P._w
    self.h      = h      or P._h
    self.k      = k      or P._k
    --  Configure font face
    self.face   = love.graphics.newImageFont(self.path, self.glyphs)
end



P.set = function (self)
    --
    --  Set the font
    --
    love.graphics.setFont(self.face)
end



P.print = function (self, text, x, y, color, center)
    --
    --  Print text and center vertically (and optionally, horizontally)
    --
    local text   = tostring(text)
    local x      = x
    local y      = y - math.floor(self.h / 2)
    local color  = color  or {1, 1, 1}
    --  Center text horizontally if specified
    if center then x = x - math.floor(((self.w + self.k) * #text) / 2) end
    love.graphics.setColor(color)
    love.graphics.print(text, x, y)
end



return P



