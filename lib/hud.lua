--
--  Heads-up display
--
local P = Class:new()



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
    love.graphics.setColor(self.outline)
    love.graphics.rectangle(
        "line",        
        self.x - 1,
        self.y - 1,
        self.width + 1,
        self.height + 1
    )
    love.graphics.setColor(self.bgcolor)
    love.graphics.rectangle(
        "fill",        
        self.x,
        self.y,
        self.width,
        self.height
    )
end



return P
