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
P.physics    = {}
P.physics.gx = 0
P.physics.gy = 0



--
--  Characters
--
P.player  = "paul"
P.playerx = X(8, true)
P.playery = Y(8, true)
P.npcs    = {
    {
        "pizza",
        X(4, true),
        Y(6, true),
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
--  Add exits to the map
--
P.exits = {
    {
        ["x"]      = X(8),
        ["y"]      = Y(8),
        ["dest"]   = {
            ["world"] = "test"
        },
    },
}



--
--  Enable Heads-Up Display
--
P.hud = true



return P 



