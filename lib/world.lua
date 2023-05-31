--
--  World mechanics for windfield
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



local Class = require("lib/30log/30log")
local P     = Class("World")



--
--  Dependencies
--
local Windfield = require("lib/windfield")
local Map       = require("lib/sti")
local Camera    = require("lib/hump/camera")
local Player    = require("lib/player")
local NPC       = require("lib/npc")
local HUD       = require("lib/hud")
local Dialog    = require("lib/dialog")
local Chest     = require("lib/chest")



P.init = function (self, path)
    --
    --  Initialize the World
    --

    --  Load data from file
    local data = assert(
        require(path),
        "Unable to load world data: "..tostring(path)
    )

    --  DEBUG Uncomment to draw queries
    --self.physics:setQueryDebugDrawing(true)

    --  Camera
    self.camera = Camera(
        math.floor(love.graphics.getWidth()  / 2),
        math.floor(love.graphics.getHeight() / 2),
        2
    )

    -- World physics and collision classes
    local physics = data.physics
    self.physics  = Windfield.newWorld(physics.gx, physics.gy)
    local classes = {
        "Wall",
        "Player",
        "NPC",
        "Enemy",
        "Item",
        "Door",
        "Chest",
        "Entity",
    }
    for _,class in pairs(classes) do self.physics:addCollisionClass(class) end

    --  Map, layers, and walls
    self.map         = Map(data.map.path)
    self.underLayers = data.map.underLayers or {}
    self.overLayers  = data.map.overLayers  or {}
    self.walls       = {}
    --  Define wall hitboxes
    if self.map.layers["walls"] then
        for _,o in pairs(self.map.layers["walls"].objects) do
            local wall = self.physics:newRectangleCollider(
                o.x,
                o.y,
                o.width,
                o.height
            )
            wall:setType("static")
            wall:setCollisionClass("Wall")
            table.insert(self.walls, wall)
        end
    end

    --  Characters
    self.characters = {}
    --  Player
    local name  = data.player
    self.player = Player:new("data/character/"..name, self.physics)
    self.player.collider:setCollisionClass("Player")
    table.insert(self.characters, self.player)
    --  NPCs
    local names = data.npcs
    for _,name in pairs(names) do
        local npc = NPC:new("data/npc/"..name, self.physics)
        npc.collider:setCollisionClass("NPC")
        table.insert(self.characters, npc)
    end

    --  Chests
    self.chests = {}
    if data.chests then
        for _,ch in pairs(data.chests) do
            local chest = Chest:new(self.physics, ch.x, ch.y, ch.contents)
            table.insert(self.chests, chest)
        end
    end


    --  HUD
    if data.hud then self.hud = HUD:new(self.player) end


end



P.update = function (self, dt)
    --
    --  Update the world
    --  TODO Better pause functionality
    --
    if not dialogActive then

        --  Get movement from keyboard input
        local pdx,pdy = 0, 0
        local pvx,pvy = self.player.vx, self.player.vy
        local pAction = "default"
        local pFacing = self.player.dir
        if love.keyboard.isDown("left") then
            pdx       = -1
            pAction   = "walk"
            pFacing   = "left"
        elseif love.keyboard.isDown("right") then
            pdx       = 1
            pAction   = "walk"
            pFacing   = "right"
        elseif love.keyboard.isDown("up") then
            pdy       = -1
            pAction   = "walk"
            pFacing   = "up"
        elseif love.keyboard.isDown("down") then
            pdy       = 1
            pAction   = "walk"
            pFacing   = "down"
        end

        --  Move player hitbox
        self.player.collider:setLinearVelocity(
            pdx * pvx,
            pdy * pvy
        )

        --  Update windfield
        self.physics:update(dt)

        --  Move and update player animatons
        local px,py        = self.player.collider:getX(), self.player.collider:getY()
        self.player.dir    = pFacing
        self.player.action = pAction
        self.player:setState()
        self.player:position(px, py)

        --  Update all characters
        local sort = function(c1, c2) return c1.collider:getY() < c2.collider:getY() end
        table.sort(self.characters, sort)
        for _,c in pairs(self.characters) do 
            if c.class == "NPC" then c:randomize(dt) end
            c:update(dt)
        end

        --  Update chests
        if self.chests then
            for _,ch in pairs(self.chests) do ch:update(dt) end
        end

        --  Update camera
        self.camera:lookAt(
                 self.player.collider:getX(),
                 self.player.collider:getY()
        )

        --  Update HUD
        if self.hud then self.hud:update(dt) end

        --  Fetch dialogs
        if not currentDialog then
            if #dialogs > 0 then currentDialog = Dialog:pop() end
        end

    end

end



P.draw = function (self)
    --
    --  Draw the world
    --
    love.graphics.setColor({1, 1, 1})

    --
    --  Set the camera
    --
    self.camera:attach()

    --  Draw map layers under characters
    if self.underLayers then
        for _,l in ipairs(self.underLayers) do
            local layer = self.map.layers[l]
            self.map:drawLayer(layer)
        end
    end
    self.map:drawLayer(self.map.layers["bg"])
    self.map:drawLayer(self.map.layers["trees_bottom"])

    --  Draw chests
    for _,ch in pairs(self.chests) do ch:draw() end

    --  Draw characters
    for _,c in pairs(self.characters) do c:draw() end

    --  Draw map layers over characters
    if self.overLayers then
        for _,l in ipairs(self.overLayers) do
            local layer = self.map.layers[l]
            self.map:drawLayer(layer)
        end
    end

    --  DEBUG Draw collision hitboxes
    --self.physics:draw()

    --
    --  Unset the camera
    --
    self.camera:detach()

    --  Draw the HUD
    if self.hud then self.hud:draw() end

    --  Draw current dialog popup
    if currentDialog then
        currentDialog:draw()
        dialogActive = true
    end

end



return P



