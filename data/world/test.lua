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
local X  = function (n, o)
    local offset = 0
    if o then offset = math.floor(tw / 2) end
    return n * tw + offset
end
local Y  = function (n, o)
    local offset = 0
    if o then offset = math.floor(th / 2) end
    return n * th + offset
end



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
P.playerx = X(46, true)
P.playery = Y(28, true)
P.npcs    = {
    {
        "punit",
        X(37, true),
        Y(23, true),
    },
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
        ["x"]      = X(46),
        ["y"]      = Y(24),
        ["locked"] = true,
        ["dest"]   = {
            ["world"] = "test2"
        },
    },
    {
        ["x"]      = X(16),
        ["y"]      = Y(23),
        ["locked"] = false,
    },
}



--
--  Add chests to the map
--
P.chests = {
    {
        ["x"]        = X(13),
        ["y"]        = Y(27),
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 50,
        },
    },
    {
        ["x"]        = X(14),
        ["y"]        = Y(27),
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 250,
        },
        ["locked"]   = true,
    },
    {
        ["x"]        = X(15),
        ["y"]        = Y(27),
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 25,
        },
    },
    {
        ["x"]        = X(40),
        ["y"]        = Y(23),
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 50,
        },
    },
    {
        ["x"]        = X(48),
        ["y"]        = Y(35),
        ["contents"] = {
            ["item"] = "money",
            ["name"] = "coins",
            ["qty"]  = 100,
        },
        ["locked"]   = true,
    },
    {
        ["x"]        = X(60),
        ["y"]        = Y(9),
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



