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
    if currentConvo then
        currentConvo:update(dt)
    elseif currentDialog then
        currentDialog:update(dt)
    end
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
                if currentDialog.options and currentDialog.texts.body:done() then
                    --  Select option and advance conversation
                    if currentConvo then
                        local npc    = currentDialog.npc
                        local nextid = currentDialog.options[currentDialog.selection].nextid
                        currentConvo:load(nextid)
                        npc:talk(currentConvo, player)
                        currentDialog.kill()
                    end
                elseif currentDialog.actions then
                    for _,id in ipairs(currentDialog.actions) do
                        local npc = currentDialog.npc
                        npc:doAction(player, id)
                        currentDialog.kill()
                    end
                else
                    if not currentDialog.texts.body:done() then
                        currentDialog.texts.body:skip()
                    else
                        currentDialog.kill()
                    end
                end
            end
        end

    --  Select option
    elseif key == "left" or key == "right" then
        if currentDialog then
            if currentDialog.options and currentDialog.texts.body:ready() then
                local num   = #currentDialog.options
                local delta = 0
                if key == "left" then
                    delta = -1
                elseif key == "right" then
                    delta = 1
                end
                currentDialog.selection = num - ((currentDialog.selection + delta) % num)
            end
        end

    --  Cycle zoom
    elseif key == "z" then
        world.zoom = ((world.zoom + 1) % 3) + 1

    --  DEBUG Heal/damage the player
    elseif key == "k" then
        player:heal(0.5)
    elseif key == "j" then
        player:damage(0.5)

    --  DEBUG Load next level
    elseif key == "n" then
        path = "data/world/test2"
        world = World(path)

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



