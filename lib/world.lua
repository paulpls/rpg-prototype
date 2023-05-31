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
local Dialog    = require("lib/dialog")
local Camera    = require("lib/hump/camera")



P.init = function (self, path)
    --
    --  Initialize the World
    --

    --  Load data from file
    local data = assert(
        require(path),
        "Unable to load world data: "..tostring(path)
    )
    self.physics    = data.physics
    self.map        = data.map
    self.player     = data.player
    self.characters = data.characters
    if data.hud    then self.hud    = data.hud    end
    if data.chests then self.chests = data.chests end

    --  DEBUG Uncomment to draw queries
    --self.physics:setQueryDebugDrawing(true)

    --  Camera
    self.camera = Camera(
        math.floor(love.graphics.getWidth()  / 2),
        math.floor(love.graphics.getHeight() / 2),
        2
    )

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

    --  Draw map layers below characters
    self.map:drawLayer(self.map.layers["bg"])
    self.map:drawLayer(self.map.layers["trees_bottom"])

    --  Draw chests
    for _,ch in pairs(self.chests) do ch:draw() end

    --  Draw characters
    for _,c in pairs(self.characters) do c:draw() end

    --  Draw map layers above characters
    self.map:drawLayer(self.map.layers["trees_top"])

    --  DEBUG Draw collision hitboxes
    --self.physics:draw()

    --
    --  Unset the camera
    --
    self.camera:detach()

    --  Draw the HUD
    self.hud:draw()

    --  Draw current dialog popup
    if currentDialog then
        currentDialog:draw()
        dialogActive = true
    end

end



return P



