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
local Door      = require("lib/door")
local Exit      = require("lib/exit")



local exists = function (name)
    --
    --  Check if file name exists
    --
    local file = io.open(name, "r")
    if file then 
        io.close(file)
        return true
    end
    return false
end



P.init = function (self, path, currentPlayer, x, y)
    --
    --  Initialize the World
    --
    self:load(path, currentPlayer, x, y)
end



P.load = function (self, path, currentPlayer, x, y)
    --
    --  Load data from file
    --

    local data = assert(
        require(path),
        "Unable to load world data: "..tostring(path)
    )

    --  Zoom and camera
    self.zoom   = data.zoom or 2
    self.camera = Camera(
        math.floor(love.graphics.getWidth()  / 2),
        math.floor(love.graphics.getHeight() / 2),
        self.zoom
    )

    -- World physics and collision classes
    local physics = data.physics
    self.physics  = Windfield.newWorld(physics.gx, physics.gy)
    --  Simple classes
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
    --  More complex classes
    self.physics:addCollisionClass(
        "OpenDoor",
        {
            ignores = {
                "Player",
            },
        }
    )

    --  DEBUG Uncomment to draw queries
    --self.physics:setQueryDebugDrawing(true)

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
    local name  = ""
    local px,py = data.playerx, data.playery
    if currentPlayer then
        --  Load in the current player and create a new collider for the current world
        self.player = currentPlayer
        self.player:newCollider(self.physics)
        self.player.collider:setPosition(px, py)
    else
        --  Create a new player as specified in the data file
        name  = data.player
        self.player = Player:new("data/character/"..name, self.physics, px, py)
        self.player.collider:setCollisionClass("Player")
    end
    table.insert(self.characters, self.player)
    --  NPCs
    local npcs = data.npcs
    for _,npcData in pairs(npcs) do
        local name,npcx,npcy = unpack(npcData)
        --  Create new NPCs
        local npc  = nil
        local Type = NPC
        --  Load custom NPC type if it exists
        local file = "lib/npcs/"..name
        if exists(file..".lua") then
            Type = require(file)
        end
        --  Set physics and add to table
        npc = Type:new("data/npc/"..name, self.physics, npcx, npcy)
        npc.collider:setCollisionClass("NPC")
        table.insert(self.characters, npc)
    end

    --  Doors
    self.doors = {}
    if data.doors then
        for _,d in pairs(data.doors) do
            local door = Door:new(self.physics, d.x, d.y, d.locked, d.dest)
            table.insert(self.doors, door)
        end
    end

    -- Exits
    if data.exits then
        for _,e in pairs(data.exits) do
            local exit = Exit:new(self.physics, e.x, e.y, e.dest)
            table.insert(self.doors, exit)
        end
    end

    --  Chests
    self.chests = {}
    if data.chests then
        for _,ch in pairs(data.chests) do
            local chest = Chest:new(self.physics, ch.x, ch.y, ch.contents, ch.locked)
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
        if love.keyboard.isDown("left") or love.keyboard.isDown("h") then
            pdx       = -1
            pAction   = "walk"
            pFacing   = "left"
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("j") then
            pdy       = 1
            pAction   = "walk"
            pFacing   = "down"
        elseif love.keyboard.isDown("up") or love.keyboard.isDown("k") then
            pdy       = -1
            pAction   = "walk"
            pFacing   = "up"
        elseif love.keyboard.isDown("right") or love.keyboard.isDown("l") then
            pdx       = 1
            pAction   = "walk"
            pFacing   = "right"
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

        --  Update doors
        self.closedDoors = {}
        self.openDoors   = {}
        if self.doors then
            for _,d in pairs(self.doors) do
                d:update(dt)
                if d.locked or not d.opened then
                    table.insert(self.closedDoors, d)
                else
                    table.insert(self.openDoors, d)
                end
            end
        end

        --  Update chests
        if self.chests then
            for _,ch in pairs(self.chests) do ch:update(dt) end
        end

        --  Update camera
        self.camera:zoomTo(self.zoom)
        self.camera:lookAt(
                 self.player.collider:getX(),
                 self.player.collider:getY()
        )

        --  Fetch dialogs
        if not currentDialog then
            if #dialogs > 0 then currentDialog = Dialog:pop() end
        end

    end

    --
    --  NOTE The following blocks will update regardless of
    --  whether or not the game is paused
    --

    --  Update HUD
    if self.hud then self.hud:update(dt) end


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

    --  Draw closed/locked doors under characters
    for _,d in pairs(self.closedDoors) do d:draw() end

    --  Draw chests
    for _,ch in pairs(self.chests) do ch:draw() end

    --  Draw characters
    for _,c in pairs(self.characters) do c:draw() end

    --  Draw open doors over characters
    for _,d in pairs(self.openDoors) do d:draw() end

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



