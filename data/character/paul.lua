--
--  Character data
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



local P = {}



--
--  Properties
--
P.name      = "Paul"
P.class     = "Player"
P.img       = "assets/img/character/paul.png"
P.x         = 1120
P.y         = 704
P.width     = 48
P.height    = 48
P.ox        = -24
P.oy        = -42
P.vx        = 85
P.vy        = 85
P.health    = 2.5
P.maxHealth = 3



--
-- Inventory
--
P.inventory = {}
P.inventory.money = 0



--
--  Collider info
--
local cWidth  = 24
local cHeight = 24
local cCutoff = 10
P.colliderInfo        = {}
P.colliderInfo.x      = P.x
P.colliderInfo.y      = P.y
P.colliderInfo.width  = cWidth
P.colliderInfo.height = cHeight
P.colliderInfo.cutoff = cCutoff


--
--  Collider-dependent properties
--
P.reach = math.floor((cWidth + cHeight) / 3)


--
--  Directions (ie spritesheet row)
--
P.facing = {}
P.facing.down  = 1
P.facing.up    = 2
P.facing.left  = 3
P.facing.right = 4



--
--  Actions
--
P.actions = {}
--  Default
P.actions.default = {
    ["frames"] = "1-1",
    ["delay"]  = 1
}
--  Walk
P.actions.walk = {
    ["frames"] = "2-5",
    ["delay"]  = 0.25
}



return P



