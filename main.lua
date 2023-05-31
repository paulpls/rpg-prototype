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
local World = require("lib/world")



--
--  RNG
--
math.randomseed(os.time())
math.random()
math.random()
math.random()



love.load = function ()
    --
    --  Load stuff and configure defaults
    --

    --  Graphics defaults
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(true)

    --  Load world from file
    world = World("data/world/test")

end



love.update = function (dt)
    --
    --  Update stuff
    --
    world:update(dt)
    if currentConvo  then  currentConvo:update(dt) end
end



love.keypressed = function (key)
    --
    --  Key bindings
    --
    local player = world.player

    --  Quit
    if key == "escape" or key == "q" then
        love.event.quit()

    --  Action (Inspect, interact, etc)
    elseif key == "space" then
        if not dialogActive and not currentConvo then
            player:inspect(world.physics)
        else
            if currentDialog then
                if currentDialog.options then
                    --  Select option and advance conversation
                    if currentConvo then
                        local npc    = currentConvo.npc
                        local player = currentConvo.player
                        local nextid = currentDialog.options[currentDialog.selection].nextid
                        currentConvo:load(nextid)
                        npc:talk(currentConvo, player)
                        currentDialog.kill()
                    else
                        --  TODO Perform actions based on option selection
                    end
                else
                    currentDialog.kill()
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



love.draw = function ()
    --
    --  Draw stuff
    --
    world:draw()
end



love.quit = function ()
end



