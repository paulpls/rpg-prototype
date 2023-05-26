--
--  Font management
--
local Font = Class:new()
Font._path   = "assets/font/pixel.png"
Font._glyphs = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
Font._w      = 16   --  Character width
Font._h      = 20   --  Character height
Font._k      = 2    --  Kerning



function Font:init(path, glyphs, w, h, k)
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



function Font:set()
    --
    --  Set the font
    --
    love.graphics.setFont(self.face)
end



return Font



