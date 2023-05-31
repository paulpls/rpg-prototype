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
local Font = require("lib/font")



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

    --  Configure font and recalculate width
    self.font  = Font:new()
    self.minW  = self.font:getWidth(text)
    self.minH  = self.font.h
    self.width = math.max(self.width, self.minW)
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
end



P.draw = function (self)
    --
    --  Draw the dialog
    --

    --  Set font
    self.font:set()

    --  Header
    if self.header then
        local scale   = 2
        local margin  = 6
        local padding = 8
        local w,h     = self.font:getWidth(self.header.text) + (margin * 2), scale * (self.minH + (margin * 2))
        local x,y     = self.x, self.y - h - margin
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
        local tx = x + padding
        local ty = y + math.floor(h / 2) - math.floor(self.font.h / 2)
        love.graphics.setColor(self.color)
        love.graphics.print(self.header.text, tx, ty)

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
    --  TODO Animate text per character
    local margin  = 16
    local tx      = self.x + margin
    local ty      = self.y + margin
    local tWidth  = self.width  - (2 * margin)
    local tHeight = self.height - (2 * margin)
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, tx, ty)

    --  Options
    if self.options then
        for i,o in ipairs(self.options) do
            --  Common parameters
            local pad  = 8
            local text = string.upper(o.text) or "OKAY"
            local w    = (pad * 2) + self.font:getWidth(text)
            local h    = (pad * 2) + self.font.h
            local tc   = self.color
            --  Determine origins for option box and text (row)
            local x  = tx + (w * (i - 1))
            local y  = self.y + self.height - h - margin
            local tx = x + pad
            local ty = y + pad
            --  Options
            local optionbg = {0, 0, 0, 0.5}
            local optionol = {1, 1, 1, 0.5}
            tc             = {1, 1, 1, 0.5}
            if self.selection then
                --  Highlight option if index matches selection
                if i == self.selection then 
                    optionol = {1, 1,   1   }
                    optionbg = {0, 0.5, 0.75}
                    tc       = self.color
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
            love.graphics.setColor(tc)
            love.graphics.print(text, tx, ty)
        end
    end

end



return P



