--
--  Non player character prototype
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



local Class     = require("lib/30log/30log")
local Character = require("lib/character")
local P         = Character:extend("NPC")



P.randomize = function (self, dt)
    --
    --  Randomize movement
    --  TODO Better random movement, add timer etc.
    --
    local dirs    = {"down", "up", "left", "right"}
    local actions = {"default", "walk"}
    local rChange = math.random(1,16)
    local rDir    = math.random(1,4)
    local rAction = math.random(1,8)
    local dx,dy   = 0, 0
    local vx,vy   = self.vx, self.vy
    local nAction = self.action
    local nFacing = self.dir
    --  Change if rChange rolls a 1
    if rChange == 1 then
        rAction = math.ceil(rAction / 4)
        nFacing = dirs[rDir]
        nAction = actions[rAction]
        if nFacing == "left" then
            dx = -1
        elseif nFacing == "right" then
            dx = 1
        elseif nFacing == "up" then
            dy = -1
        elseif nFacing == "down" then
            dy = 1
        end
        --  Move self hitbox
        self.collider:setLinearVelocity(
            dx * vx,
            dy * vy
        )
    end
    --  Move and update NPC animatons
    local x,y   = self.collider:getX(), self.collider:getY()
    self.dir    = nFacing
    self.action = nAction
    self:setState()
    self:position(x, y)
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



P.talk = function (self)
    --
    --  TODO Add some dialogs for player interaction
    --
end



return P



