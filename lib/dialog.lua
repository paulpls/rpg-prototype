--
--  Dialog boxes
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
local P     = Class("Dialog")
dialogs     = {}



--
--  Dependencies
--
local Text = require("lib/text")



--
--  Global stack operations
--
P.push = function (dialog)  table.insert(dialogs, dialog) end 
P.pop  = function () return table.remove(dialogs, 1)      end



--
--  Flags and other globals
--
currentDialog = nil
dialogActive  = false



P.init = function (self, text, header, options, color)
    --
    --  Initialize the dialog
    --
    self.width   = math.floor(love.graphics.getWidth()  / 3)
    self.height  = math.floor(love.graphics.getHeight() / 4)
    self.x       = math.floor(love.graphics.getWidth()  / 2) - math.floor(self.width  / 2)
    self.y       = math.floor(love.graphics.getHeight() / 2) + math.floor(self.height / 2)
    self.header  = header
    self.text    = text
    self.options = options
    self.color   = color or {1, 1, 1}
    self.bgcolor = {0, 0, 0, 0.75}
    self.outline = {1, 1, 1, 0.75}
    --  Buffer and delay for option select
    self.delay        = 0
    self.resetDelay   = function (self, t) self.delay = t or 0.33 end
    
    --  Keep track of selection, default to first option
    if self.options then self.selection = 1 end

    --  Text wrappers
    self.texts = {}
    if self.header then self.texts.header = Text:new(self.header.text) end
    if self.text   then self.texts.text   = Text:new(self.text)        end

end



P.kill = function ()
    --
    --  Kill the dialog and set the global activity flag
    --
    dialogActive  = false
    currentDialog = nil
end



P.update = function (self, dt)
    --
    --  Update the dialog
    --
    self.delay = self.delay - dt
    if self.delay <= 0 then
        if self.options then
            local delta    = 0
            if love.keyboard.isDown("left")  then delta = -1 end
            if love.keyboard.isDown("right") then delta =  1 end
            local new      = self.selection + delta
            local max      = #self.options
            self.selection = max - (new % max)
            self:resetDelay()
        end
    end
    --  Update text wrappers
    for _,t in pairs(self.texts) do t:update(dt) end
end



P.draw = function (self)
    --
    --  Draw the dialog
    --

    --  Header
    if self.texts.header then
        local text    = self.texts.header
        local scale   = 2
        local margin  = 6
        local padding = 8
        local w,h     = text:getWidth() + (margin * 2), scale * (text:getHeight() + (margin * 2))
        local x,y     = self.x, self.y - h - margin
        local color   = self.header.color or self.color
        if self.header.img then
            local imgX,imgY = x, y
            local imgW,imgH = self.header.img:getDimensions()
            imgW,imgH       = scale * imgW, scale * imgH
            --  Move text x coord to right of image
            x = x + imgW + margin
            --  Outlines
            love.graphics.setColor(self.outline)
            love.graphics.rectangle(
                "line",        
                imgX - 1,
                imgY - 1,
                imgW + 2,
                imgH + 2
            )
            --  Backgrounds
            love.graphics.setColor(self.bgcolor)
            love.graphics.rectangle(
                "fill",
                imgX,
                imgY,
                imgW,
                imgH
            )
            --  Portrait
            love.graphics.setColor({1, 1, 1})
            love.graphics.draw(
                self.header.img,
                imgX,
                imgY,
                0,
                scale,
                scale
            )
        end
        --  Outlines
        love.graphics.setColor(self.outline)
        love.graphics.rectangle(
            "line",        
            x - 1,
            y - 1,
            w + 2,
            h + 2
        )
        --  Backgrounds
        love.graphics.setColor(self.bgcolor)
        love.graphics.rectangle("fill", x, y, w, h)

        --  Header text
        text.x     = x + padding
        text.y     = y + math.floor(h / 2) - math.floor(text.h / 2)
        text.color = color
        text:draw()

    end

    --  Outline
    love.graphics.setColor(self.outline)
    love.graphics.rectangle(
        "line",        
        self.x - 1,
        self.y - 1,
        self.width + 2,
        self.height + 2
    )

    --  Background
    love.graphics.setColor(self.bgcolor)
    love.graphics.rectangle(
        "fill",        
        self.x,
        self.y,
        self.width,
        self.height
    )
    
    --  Text
    local text    = self.texts.text
    local margin  = 16
    text.x        = self.x + margin
    text.y        = self.y + margin
    text.color    = self.color
    text:draw()

    --  Options
    if self.options then
        for i,o in ipairs(self.options) do
            --  Common parameters
            local pad         = 8
            local t           = string.upper(o.text) or "OKAY"
            local label       = Text:new(t)
            local w           = (pad * 2) + label.w
            local h           = (pad * 2) + label.h
            --  Determine origins for option box and text (row)
            local x  = text.x + (w * (i - 1))
            local y  = self.y + self.height - h - margin
            label.x = x + pad
            label.y = y + pad
            --  Options
            local optionbg = {0, 0, 0, 0.5}
            local optionol = {1, 1, 1, 0.5}
            label.color    = {1, 1, 1, 0.5}
            if self.selection then
                --  Highlight option if index matches selection
                if i == self.selection then 
                    optionol = {1, 1,   1   }
                    optionbg = {0, 0.5, 0.75}
                    label.color = self.color
                end
            end
            --  Options outlines
            love.graphics.setColor(optionol)
            love.graphics.rectangle(
                "line",
                x - 1,
                y - 1,
                w + 2,
                h + 2
            )
            --  Options backgrounds
            love.graphics.setColor(optionbg)
            love.graphics.rectangle("fill", x, y, w, h)
            --  Draw option text
            label:draw()
        end
    end

end



return P



