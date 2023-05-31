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
--  Physics
--
P.physics = {}
P.physics.gx = 0
P.physics.gy = 0



--
--  Characters
--
P.player = "paul"
P.npcs   = {
    "punit",
}



--
--  Map and layers
--
P.map             = {}
P.map.path        = "data/map/map.lua"
P.map.underLayers = {
    "bg",
    "trees_bottom",
}
P.map.overLayers  = {
    "trees_top",
}



--
--  Add chests to the map
--
P.chests = {
    {
        ["x"]        = 128,
        ["y"]        = 128,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 5
        }
    },
    {
        ["x"]        = 448,
        ["y"]        = 736,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 10
        }
    },
    {
        ["x"]        = 256,
        ["y"]        = 448,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 5
        }
    },
    {
        ["x"]        = 704,
        ["y"]        = 160,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 30
        }
    },
}



--
--  Enable Heads-Up Display
--
P.hud = true



return P 



