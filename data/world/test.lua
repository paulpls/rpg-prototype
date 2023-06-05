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
local X  = function (n) return n * tw end
local Y  = function (n) return n * th end



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
    "house_bottom",
    "trees_bottom",
}
P.map.overLayers  = {
    "trees_top",
    "shadows",
    "house_top",
    "house_roof",
}



--
--  Add doors to the map
--
P.doors = {
    {
        ["x"]      = 1472,
        ["y"]      = 768,
        ["locked"] = true
    },
    {
        ["x"]      = 512,
        ["y"]      = 736,
        ["locked"] = false
    },
}



--
--  Add chests to the map
--
P.chests = {
    {
        ["x"]        = 416,
        ["y"]        = 864,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 50,
        },
    },
    {
        ["x"]        = 448,
        ["y"]        = 864,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 250,
        },
        ["locked"]   = true,
    },
    {
        ["x"]        = 480,
        ["y"]        = 864,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 25,
        },
    },
    {
        ["x"]        = 480,
        ["y"]        = 864,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 25,
        },
    },
    {
        ["x"]        = 1280,
        ["y"]        = 736,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 50,
        },
    },
    {
        ["x"]        = 1536,
        ["y"]        = 1120,
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 100,
        },
        ["locked"]   = true,
    },
    {
        ["x"]        = 1920,
        ["y"]        = 288,
        ["contents"] = {
            ["item"] = "key",
            ["name"] = "key",
            ["qty"]  = 1,
        },
    },
}



--
--  Enable Heads-Up Display
--
P.hud = true



return P 



