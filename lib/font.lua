--
--  Font management
--
local Font = Class:new()
Font._path   = "assets/font/pixel.png"
Font._glyphs = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
Font._w      = 16   --  Character width
Font._h      = 20   --  Character height
Font._k      = 2    --  Kerning



Font.init = function (self, path, glyphs, w, h, k)
    --
    --  Initialize font
    --
    self.path   = path   or Font._path
    self.glyphs = glyphs or Font._glyphs
    self.w      = w      or Font._w
    self.h      = h      or Font._h
    self.k      = k      or Font._k
    --  Configure font face
    self.face   = love.graphics.newImageFont(self.path, self.glyphs)
end



Font.set = function (self)
    --
    --  Set the font
    --
    love.graphics.setFont(self.face)
end



Font.print = function (self, text, x, y, color, center)
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



return Font



