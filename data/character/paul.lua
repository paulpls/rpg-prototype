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
P.path      = "assets/img/character/paul.png"
P.x         = 128
P.y         = 128
P.width     = 48
P.height    = 48
P.ox        = -24
P.oy        = -42
P.vx        = 85
P.vy        = 85
P.health    = 2.5
P.maxHealth = 3



--
--  Collider info
--
P.colliderInfo = {
    ["x"]      = P.x + math.floor(math.abs(P.ox) / 2),
    ["y"]      = P.y - math.abs(P.oy),
    ["width"]  = 24,
    ["height"] = 24,
    ["cutoff"] = 10
}


--
--  Directions (ie spritesheet row)
--
P.facing = {
    ["down"]  = 1,
    ["up"]    = 2,
    ["left"]  = 3,
    ["right"] = 4
}



--
--  Actions
--
P.actions = {
    ["default"] = {
        ["frames"] = "1-1",
        ["delay"]  = 1
    },
    ["walk"] = {
        ["frames"] = "2-5",
        ["delay"]  = 0.25
    }
}



return P



