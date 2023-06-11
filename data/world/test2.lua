--
--  Datasheet for world `test`
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
--  Coordinates
--
local tw = 32
local th = 32
local X  = function (n) return n * tw + math.floor(tw / 2) end
local Y  = function (n) return n * th + math.floor(th / 2) end



--
--  Physics
--
P.physics = {}
P.physics.gx = 0
P.physics.gy = 0



--
--  Characters
--
P.player  = "paul"
P.playerx = X(8)
P.playery = Y(8)
P.npcs    = {
    {
        "pizza",
        X(4),
        Y(6),
    },
}



--
--  Map and layers
--
P.map             = {}
P.map.path        = "data/map/house.lua"
P.map.underLayers = {
    "bg",
    "layer1",
}
P.map.overLayers  = {
    --
}



--
--  Add doors to the map
--
P.doors = {
--    {
--        ["x"]      = 512,
--        ["y"]      = 736,
--        ["opened"] = true
--    },
}



--
--  Add chests to the map
--
P.chests = {
--    {
--        ["x"]        = 416,
--        ["y"]        = 864,
--        ["contents"] = {
--            ["item"] = "money",
--            ["name"] = "coins",
--            ["qty"]  = 50,
--        },
--    },
}



--
--  Enable Heads-Up Display
--
P.hud = true



return P 



