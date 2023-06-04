--
--  Character model
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
local P     = Class("Character")



--
--  Dependencies
--
local Animation = require("lib/anim8/anim8")



--
--  Random animation timer
--
math.randomseed(os.time())
for _=1,5 do math.random() end
local delay      = 1
local timer      = delay
local resetTimer = function (n) timer = n or delay end



P.init = function (self, path, physics, x, y, class)
    --
    --  Initialize the character
    --

    --  Load data from file
    local data = assert(
        require(path),
        "Unable to load character data: "..tostring(path)
    )

    --  Character name
    self.name = data.name or "Stranger"

    --  Character portrait
    local portrait = data.portrait or "assets/img/npc/default_portrait.png"
    self.portrait  = love.graphics.newImage(portrait)

    --  Character class
    self.class = class or data.class

    --  Configure image and grid properties
    self.img  = love.graphics.newImage(data.img)
    self.grid = Animation.newGrid(
        data.width,
        data.height,
        self.img:getWidth(),
        self.img:getHeight()
    )

    --  Position
    self.x = x or data.x
    self.y = y or data.y

    --  Offset
    self.ox = data.ox or 0
    self.oy = data.oy or 0

    -- Speed
    self.vx = data.vx or 50
    self.vy = data.vy or 50

    --  Animations
    self.action  = "default"
    self.dir     = "down"
    self.facing  = data.facing
    self.actions = data.actions
    self.state   = nil
    self.states  = {}
    for f,row in pairs(self.facing) do
        for a,info in pairs(self.actions) do
            local name   = a.."_"..f
            self.states[name] = Animation.newAnimation(
                self.grid(info.frames, row),
                info.delay
            )
        end
    end

    --  Define collider
    self.physics = physics
    local c    = data.colliderInfo
    self.collider = self.physics:newBSGRectangleCollider(
        c.x,
        c.y,
        c.width,
        c.height,
        c.cutoff
    )
    self.collider:setFixedRotation(true)
    self.collider.parent = self

    --  Health
    self.health    = data.health    or 3
    self.maxHealth = data.maxHealth or 3

    --  Reach distance, defaults to average of collider dimensions
    if data.reach then self.reach = data.reach end

    --  Inventory
    if data.inventory then self.inventory = data.inventory end

    --  Conversation
    if data.conversation then self.conversation = data.conversation end

end



P.getState = function (self)
    --
    --  Get current animation state
    --
    if self.state then
        return self.state
    else
        local name = self.action..self.dir
        return self.states[name]
    end
end



P.setState = function (self)
    --
    --  Update the current animation state
    --
    local name  = self.action.."_"..self.dir
    self.state  = self.states[name]
end



P.query = function (self, classes, reach, radius)
    --
    --  Inspect the area in front of the character
    --
    local reach = 0
    if self.reach then reach = self.reach else reach = reach end
    local qr    = radius or 8
    local qx,qy = self.collider:getPosition()
    local classes = classes
    --  Offset the query area
    if self.dir == "left" then
        qx = qx - reach
    elseif self.dir == "right" then
        qx = qx + reach
    elseif self.dir == "up" then
        qy = qy - reach
    elseif self.dir == "down" then
        qy = qy + reach
    end
    --  Return matching objects
    return self.physics:queryCircleArea(qx, qy, qr, classes)
end



P.inspect = function (self)
    --
    --  Inspect the area in front of the character and return true if collisions are found
    --
    local classes = {
        "Wall",
        "Door",
        "Chest",
        "Player",
        "NPC",
    }
    local collision = false
    for _,class in pairs(classes) do
        if self.collider:enter(class) then
            collision = true
        end
    end
    --  Return true if facing a collidable object
    if collision then
        if #self:query(classes) > 0 then return true end
    end
    return false
end



P.randomize = function (self, dt)
    --
    --  Randomize movement
    --
    local dirs    = {"down", "up", "left", "right"}
    local actions = {"default", "walk"}
    local rChance = math.random(1, 100)
    local rDir    = math.random(1, #dirs)
    local dx,dy   = 0, 0
    local vx,vy   = self.vx, self.vy
    local nAction = self.action
    local nFacing = self.dir

    --  Change direction occasionally
    if rChance == 1 then nFacing = dirs[rDir] end
    --  Timed animation
    timer = timer - dt
    if timer <= 0 then
        if nAction == "walk" then
            if math.random(1, 20) == 1 then
                nAction = "default"
            end
            resetTimer(5)
        elseif nAction == "default" then
            if math.random(1, 3) == 1 then
                nAction = "walk"
            end
            resetTimer(1)
        end
    end
    --  Walk it out
    if nAction == "walk" then
        if nFacing == "left" then
            dx = -1
        elseif nFacing == "right" then
            dx = 1
        elseif nFacing == "up" then
            dy = -1
        elseif nFacing == "down" then
            dy = 1
        end
    end
    --  Move hitbox
    self.collider:setLinearVelocity(
        dx * vx,
        dy * vy
    )

    --  Move and update animatons
    local x,y   = self.collider:getX(), self.collider:getY()
    self.dir    = nFacing
    self.action = nAction
    self:setState()
    self:position(x, y)

    --  Stop walking if collisions are detected
    if self.action == "walk" then
        local collision = self:inspect()
        if collision then
            self.action = "default"
        end
    end

end



P.face = function (self, char, halt)
    --
    --  Face the character toward another character and optionally halt movement
    --
    local dir   = char.dir
    --  Set direction to opposite that of other character
    local opposite = {}
    opposite.down  = "up"
    opposite.up    = "down"
    opposite.left  = "right"
    opposite.right = "left"
    self.dir       = opposite[dir]
    --  Halt movement
    if halt then self.action = "default" end
end



P.move = function (self, x, y)
    --
    --  Move the character by a specified amount
    --
    local dx = self.x + (self.vx * x)
    local dy = self.y + (self.vy * y)
    self:position(dx, dy)
end



P.position = function (self, x, y)
    --
    --  Position the character at the specified coordinates
    --
    if x then self.x = x + self.ox end
    if y then self.y = y + self.oy end
end



P.heal = function (self, n)
    --
    --  Heal the character by `n` points; fully heals if no value given
    --
    if n then
        local health = self.health + n
        self.health  = math.min(health, self.maxHealth)
    else
        self.health  = self.maxHealth
    end
end



P.damage = function (self, n)
    --
    --  Damage the character by `n` points
    --
    local health = self.health - n
    self.health  = math.max(health, 0)
end



P.getItem = function (self, item, qty)
    --
    --  Add items to inventory
    --
    local qty = qty or 1
    local success = false
    if self.inventory[item] then
        self.inventory[item] = self.inventory[item] + qty
        success = true
    else
        self.inventory[item] = qty
        success = true
    end
    return success
end



P.delItem = function (self, item, qty)
    --
    --  Delete items from inventory; returns true if successful
    --
    local qty = qty or 1
    local success = false
    if self.inventory[item] then
        if self.inventory[item] >= qty then
            self.inventory[item] = self.inventory[item] - qty
            success = true
        end
    end
    return success
end



P.giveItem = function (self, player, item, qty, price)
    --
    --  Give the player items from the inventory and remove money from inventory
    --
    local qty   = qty   or 1
    local price = price or 0
    if self.inventory then
        if self:delItem(item, qty) then
            if player:getItem(item, qty) then
                player:delItem("money", price)
            end
        end
    end
end



P.update = function (self, dt)
    --
    --  Update the character sprite and animation
    --
    if not self:getState() then self:setState() end
    self:getState():update(dt)
    --  Reset some animations if not moving
    if self.action ~= "walk" then
        for f,_ in pairs(self.facing) do
            self.states["walk_"..f]:gotoFrame(1)
        end
    end
end



P.draw = function (self)
    --
    --  Draw the character
    --
    self:getState():draw(
        self.img, 
        self.x,
        self.y
    )
end



return P



