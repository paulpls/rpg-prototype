--
--  Heads-up display
--
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
        ["money"] = love.graphics.newQuad(0, 0, 16, 16, self.icons),
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
        local ix  = self.x + 16
        local iy  = self.y + math.floor(self.height / 2) - 8
        local mx  = ix + 24
        local my  = self.y + math.floor(self.height / 2)
        local qty = self.content.money
        love.graphics.setColor({1, 1, 1})
        love.graphics.draw(self.icons, self.quads.money, ix, iy)
        self.font:print(qty, mx, my)
    end
end



return P
