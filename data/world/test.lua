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
--  Dependencies
--
local Windfield = require("lib/windfield")
local Player    = require("lib/player")
local NPC       = require("lib/npc")
local HUD       = require("lib/hud")
local Map       = require("lib/sti")
local Chest     = require("lib/chest")



P.physics = Windfield.newWorld(0, 0)
P.physics:addCollisionClass("Wall")
P.physics:addCollisionClass("Player")
P.physics:addCollisionClass("NPC")
P.physics:addCollisionClass("Enemy")
P.physics:addCollisionClass("Item")
P.physics:addCollisionClass("Door")
P.physics:addCollisionClass("Chest")
P.physics:addCollisionClass("Entity")



--  Tables
P.characters = {}
P.chests     = {}



--
--  Player
--
local pName = "paul"
P.player    = Player:new("data/character/"..pName, P.physics)
P.player.collider:setCollisionClass("Player")
table.insert(P.characters, P.player)



--
--  NPCs
--
local names = {
    "punit",
}
for _,name in pairs(names) do
    local npc = NPC:new("data/npc/"..name, P.physics)
    npc.collider:setCollisionClass("NPC")
    table.insert(P.characters, npc)
end



--
--  Heads-Up Display
--

P.hud = HUD:new(P.player)



--
--  Map
--
P.map = Map("data/map/map.lua")
--  Define wall hitboxes
if P.map.layers["walls"] then
    for _,o in pairs(P.map.layers["walls"].objects) do
        local wall = P.physics:newRectangleCollider(
            o.x,
            o.y,
            o.width,
            o.height
        )
        wall:setType("static")
        wall:setCollisionClass("Wall")
        table.insert(walls, wall)
    end
end



--
--  Add chests to the map
--  TODO Make these more abstract eventually by loading from data files
--
local _chests  = {
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
for _,ch in pairs(_chests) do
    local chest = Chest:new(P.physics, ch.x, ch.y, ch.contents)
    table.insert(P.chests, chest)
end



return P 



