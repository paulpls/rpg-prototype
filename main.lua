--
--  RPG Prototype
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



--
--  Dependencies
--
local Character = require("lib/character")
local Chest     = require("lib/chest")
local HUD       = require("lib/hud")
--  Third-party stuff
local Map       = require("lib/sti")
local Camera    = require("lib/hump/camera")
local Windfield = require("lib/windfield")



love.load = function ()
    --
    --  Load stuff and configure defaults
    --

    --  Graphics defaults
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(true)

    --  World setup
    world = Windfield.newWorld(0, 0)
    world:addCollisionClass("wall")
    world:addCollisionClass("player")
    world:addCollisionClass("npc")
    world:addCollisionClass("enemy")
    world:addCollisionClass("item")
    world:addCollisionClass("door")
    world:addCollisionClass("chest")
    world:addCollisionClass("entity")
    --  DEBUG Draw queries
    --world:setQueryDebugDrawing(true)

    --  Load player sprite into the world
    player = Character:new("data/character/paul", world)
    player.collider:setCollisionClass("player")

    --  Camera setup
    camera = Camera(
        math.floor(love.graphics.getWidth()  / 2),
        math.floor(love.graphics.getHeight() / 2),
        2
    )

    --  Heads-Up Display
    hud = HUD:new(player)

    --  Load the map
    map = Map("data/map/map.lua")

    --  Define wall hitboxes
    walls = {}
    if map.layers["walls"] then
        for _,o in pairs(map.layers["walls"].objects) do
            local wall = world:newRectangleCollider(
                o.x,
                o.y,
                o.width,
                o.height
            )
            wall:setType("static")
            wall:setCollisionClass("wall")
            table.insert(walls, wall)
        end
    end

    --  Add chests to the map
    --  TODO Make these more abstract eventually by loading from data files
    chests         = {}
    local _chests  = {
        {
            ["x"]        = 128,
            ["y"]        = 128,
            ["contents"] = {
                ["name"] = "money",
                ["qty"]  = 5
            }
        },
        {
            ["x"]        = 448,
            ["y"]        = 736,
            ["contents"] = {
                ["name"] = "money",
                ["qty"]  = 10
            }
        },
        {
            ["x"]        = 256,
            ["y"]        = 448,
            ["contents"] = {
                ["name"] = "money",
                ["qty"]  = 5
            }
        },
        {
            ["x"]        = 704,
            ["y"]        = 160,
            ["contents"] = {
                ["name"] = "money",
                ["qty"]  = 30
            }
        },
    }
    for _,ch in pairs(_chests) do
        local chest = Chest:new(world, ch.x, ch.y, ch.contents)
        table.insert(chests, chest)
    end

end



love.update = function (dt)
    --
    --  Update stuff
    --

    --  Get movement from keyboard input
    local pdx,pdy = 0, 0
    local pvx,pvy = player.vx, player.vy
    local pAction = "default"
    local pFacing = player.dir
    if love.keyboard.isDown("left") then
        pdx,pdy   = -1, 0
        pAction   = "walk"
        pFacing   = "left"
    elseif love.keyboard.isDown("right") then
        pdx,pdy   = 1, 0
        pAction   = "walk"
        pFacing   = "right"
    elseif love.keyboard.isDown("up") then
        pdx,pdy   = 0, -1
        pAction   = "walk"
        pFacing   = "up"
    elseif love.keyboard.isDown("down") then
        pdx,pdy   = 0, 1
        pAction   = "walk"
        pFacing   = "down"
    end

    --  Move player hitbox
    player.collider:setLinearVelocity(
        pdx * pvx,
        pdy * pvy
    )

    --  Update windfield
    world:update(dt)

    --  Move and update player animatons
    local px,py   = player.collider:getX(), player.collider:getY()
    player.dir    = pFacing
    player.action = pAction
    player:setState()
    player:position(px, py)
    player:update(dt)

    --  Update chests
    for _,ch in pairs(chests) do ch:update(dt) end

    --  Update camera
    camera:lookAt(
        player.collider:getX(),
        player.collider:getY()
    )

    --  Update HUD
    hud:update(dt)

end



love.draw = function ()
    --
    --  Draw stuff
    --
    love.graphics.setColor({1, 1, 1})

    --
    --  Set the camera
    --
    camera:attach()

    --  Draw map layers below characters
    map:drawLayer(map.layers["bg"])
    map:drawLayer(map.layers["trees_bottom"])

    --  Draw chests
    for _,ch in pairs(chests) do
        ch:draw()
    end

    --  Draw characters
    player:draw()

    --  Draw map layers above characters
    map:drawLayer(map.layers["trees_top"])

    --  DEBUG Draw collision hitboxes
    --world:draw()

    --
    --  Unset the camera
    --
    camera:detach()

    --  Draw the HUD
    hud:draw()


end



love.keypressed = function (key)
    --
    --  Key bindings
    --

    --  Quit
    if key == "escape" or key == "q" then
        love.event.quit()

    --  Query
    elseif key == "space" then
        local qx,qy = player.collider:getPosition()
        local reach = player.reach
        --  Offset the query area
        if player.dir == "left" then
            qx = qx - reach
        elseif player.dir == "right" then
            qx = qx + reach
        elseif player.dir == "up" then
            qy = qy - reach
        elseif player.dir == "down" then
            qy = qy + reach
        end
        local objs  = world:queryCircleArea(qx, qy, 12, {"chest"})
        if #objs > 0 then
            for i,obj in ipairs(objs) do
                if obj.parent then
                    local contents = obj.parent:interact()
                    if contents then player:getItem(contents) end
                end
            end
        end

    --  DEBUG Heal/damage the player
    elseif key == "k" then
        player:heal(0.5)
    elseif key == "j" then
        player:damage(0.5)
    end

end



love.quit = function ()
end



