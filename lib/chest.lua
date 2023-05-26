--
--  Chest model
--
local P = Class:new()
P.img  = love.graphics.newImage("assets/img/sprite/chest.png")
P.quads = {
    ["closed"] = love.graphics.newQuad(0,  0, 32, 32, P.img),
    ["open"]   = love.graphics.newQuad(32, 0, 32, 32, P.img)
}



P.init = function (self, world, x, y, contents)
    --
    --  Initialize a new chest
    --
    self.x        = x or 0 
    self.y        = y or 0
    self.contents = contents
    self.open     = false
    self.quad     = P.quads.closed
    self.collider = world:newRectangleCollider(
        self.x + 4,
        self.y + 8,
        24,
        20
    )
    self.collider:setCollisionClass("chest")
    self.collider:setType("static")
    self.collider.parent = self
end



P.interact = function (self)
    --
    --  Open the chest and return contents
    --
    if not self.open then
        self.open = true
        return self.contents
    end
end



P.update = function (self, dt)
    --
    --  Update the chest
    --
    if self.open then
        self.quad = P.quads.open
    else
        self.quad = P.quads.closed
    end
end



P.draw = function (self)
    --
    --  Draw the chest
    --
    local quad = P.quads.closed
    if self.open then
        local quad = P.quads.open
    end
    love.graphics.draw(
        P.img,
        self.quad,
        self.x,
        self.y
    )
end



return P



