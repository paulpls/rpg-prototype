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



P.init = function (self, body, header, options, color)
    --
    --  Initialize the dialog
    --
    self.width      = math.floor(love.graphics.getWidth()  / 3)
    self.height     = math.floor(love.graphics.getHeight() / 4)
    self.x          = math.floor(love.graphics.getWidth()  / 2) - math.floor(self.width  / 2)
    self.y          = math.floor(love.graphics.getHeight() / 2) + math.floor(self.height / 2)
    self.header     = header
    self.body       = body
    self.options    = options
    self.color      = color or {1, 1, 1}
    self.bgcolor    = {0, 0, 0, 0.75}
    self.outline    = {1, 1, 1, 0.75}
    self.margin     = 6
    self.padding    = 16
    self.imgScale   = 4
    
    --  Keep track of selection, default to first option
    if self.options then self.selection = 1 end

    --  Text wrappers
    self.texts = {}
    --  Header
    if self.header then
        local headerOptions = {}
        headerOptions.color = self.color
        self.texts.header   = Text:new(
            self.header.text,
            headerOptions
        )
    end
    --  Body
    local bodyOptions  = {}
    bodyOptions.maxW   = self.width  - (2 * self.padding) - self.margin
    bodyOptions.maxH   = self.height - (2 * self.padding) - self.margin
    bodyOptions.color  = self.color
    bodyOptions.tick   = true
    bodyOptions.scroll = true
    self.texts.body = Text:new(
        self.body,
        bodyOptions
    )

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
    --  Update text wrappers
    --
    for _,t in pairs(self.texts) do t:update(dt) end
end



P.draw = function (self)
    --
    --  Draw the dialog
    --
    local x,y = self.x, self.y
    local scale   = self.imgScale
    local margin  = self.margin
    local padding = self.padding

    --  Header Portrait
    if self.header then
        if self.header.img then
            --  Get scale and portrait dimensions
            local imgW,imgH = self.header.img:getDimensions()
            imgW,imgH       = scale * imgW, scale * imgH
            local imgX,imgY = x - imgW - margin, y
            --  Portrait outline
            love.graphics.setColor(self.outline)
            love.graphics.rectangle(
                "line",        
                imgX - 1,
                imgY - 1,
                imgW + 2,
                imgH + 2
            )
            --  Portrait background
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

    --  Set up body text
    local text    = self.texts.body
    text.x        = self.x + padding
    text.y        = self.y + padding

    --  Set up and draw header text
    if self.header then
        if self.texts.header then
            local head    = self.texts.header
            local w,h     = head:getWidth() + (padding * 2), scale * (head:getHeight() + (padding * 2))
            head.x        = self.x + padding
            head.y        = self.y + padding --+math.floor(h / 2) - math.floor(text.h / 2)
            head.color    = self.header.color or self.color
            head:draw()
            --  Increase body y coord to render below header text
            text.y = text.y + head:getHeight() + padding
        end
    end
    
    --  Draw body text
    text:draw()

    --  Options
    local finished = text:ready()
    if finished and self.options then
        for i,o in ipairs(self.options) do
            --  Label parameters
            local pad        = 8
            local labelText  = o.text or "Okay"
            local labelColor = {1, 1, 1, 0.5}
            --  Create label
            local options = {}
            options.color = labelColor
            local label   = Text:new(
                labelText,
                options
            )
            local w = (pad * 2) + label.w
            local h = (pad * 2) + label.h
            --  Determine origins for option container
            local x = text.x + (w * (i - 1))
            local y = self.y + self.height - h - padding
            --  Set up option background and outline
            local optionbg    = {0, 0, 0, 0.5}
            local optionol    = {1, 1, 1, 0.5}
            if self.selection then
                --  Highlight option if index matches selection
                if i == self.selection then 
                    optionol    = {1,   1,   1        }
                    optionbg    = {0,   0.5, 0.75     }
                    label.color = self.color
                end
            end
            --  Draw option outline
            love.graphics.setColor(optionol)
            love.graphics.rectangle(
                "line",
                x - 1,
                y - 1,
                w + 2,
                h + 2
            )
            --  Draw option background
            love.graphics.setColor(optionbg)
            love.graphics.rectangle("fill", x, y, w, h)
            --  Draw option text
            label.x    = x + pad
            label.y    = y + pad
            label.w    = w
            label.h    = h
            label.maxW = w
            label.maxH = h
            label:draw()
        end
    end

end



return P



