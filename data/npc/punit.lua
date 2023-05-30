--
--  Character data
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
--  Properties
--
P.name      = "Punit"
P.class     = "NPC"
P.path      = "assets/img/npc/punit.png"
P.x         = 480
P.y         = 704
P.width     = 48
P.height    = 48
P.ox        = -24
P.oy        = -42
P.vx        = 50
P.vy        = 50



--
--  Collider info
--
local cWidth   = 24
local cHeight  = 24
local cCutoff  = 10
P.colliderInfo = {}
P.colliderInfo.x      = P.x
P.colliderInfo.y      = P.y
P.colliderInfo.width  = cWidth
P.colliderInfo.height = cHeight
P.colliderInfo.cutoff = cCutoff


--
--  Collider-dependent properties
--
P.reach = math.floor((cWidth + cHeight) / 2)


--
--  Directions (ie spritesheet row)
--
P.facing = {}
P.facing.down  = 1
P.facing.up    = 2
P.facing.left  = 3
P.facing.right = 4



--
--  Actions
--
P.actions = {}
--  Default
P.actions.default = {
    ["frames"] = "1-1",
    ["delay"]  = 1
}
--  Walk
P.actions.walk = {
    ["frames"] = "2-5",
    ["delay"]  = 0.25
}



--
--  Conversations
--
--  C = {}      Conversations table
--  C.id        Conversation id string
--  C.id.msgs   Conversation messages tables
--      {
--          [1] = {"msg1", "msg2", "msg3"},   Random options for message 1
--          [2] = {"msg"},                    Single message for message 2
--      }
--  C.nextid    Next conversation set
--  C.previd    Prev conversation set (eg "Did you catch all that?" -> "No" -> repeat)
--  C.options   Options tables
--      {
--          ["id"] = {
--              ["text"]   = "name"    Name of option, `id` if omitted
--              ["nextid"] = id        ID of next conversation set upon selection
--          },
--      }
--  C.actions   TODO Actions to take, such as give item, take money, heal player, etc
--  C.stop      If true, signifies that the conversation will forcibly stop after this point
--
C = {}

--  Hello (default)
C.hello      = {}
C.hello.msgs = {}
table.insert(
    C.hello.msgs,
    {
        "Hello",
        "Hi",
        "Hey",
        "Sup",
        "Hey there",
        "How goes it",
    }
)
C.hello.stop = true

--  Buy items intro
C.buy        = {}
C.buy.msgs   = {}
table.insert(
    C.buy.msgs,
    {
        "Buy something will ya",
        "Khajit has wares if you have coin",
    }
)
table.insert(
    C.buy.msgs,
    {
        "Today I will give you a special deal",
        "I promise it is worth your while",
    }
)
C.buy.nextid = "buyYN"

--  Buy items Y/N
C.buyYN             = {}
C.buyYN.msgs        = {}
table.insert(
    C.buyYN.msgs,
    {
        "I will sell you this mysterious key for 50 coins"
    }
)
C.buyYN.options     = {}
C.buyYN.options.yes = {
    ["text"]   = "yes",
    ["nextid"] = "buyThanks",
}
C.buyYN.options.no  = {
    ["text"]   = "no",
    ["nextid"] = "bye",
}

--  Buy items thank you
C.buyThanks        = {}
C.buyThanks.msgs   = {}
table.insert(
    C.buyThanks.msgs,
    {
        "Thanks",
        "Thank you",
        "Sweet thanks",
        "Thank you so much",
        "Pleasure doing business with you",
        "Fanks m8",
    }
)
C.buyThanks.actions = {}
table.insert(
    C.buyThanks.actions,
    {
        ["action"] = "buy",
        ["item"]   = "mysterious_key",
        ["cost"]   = 50,
    }
)
C.buyThanks.stop   = true

--  Goodbye
C.bye             = {}
C.bye.msgs        = {}
table.insert(
    C.bye.msgs,
    {
        "Bye Felicia",
        "Seeya later then",
        "You do you boo",
    }
)
C.bye.stop        = true


--
--  Add conversations to NPC
--
P.conversation = C



return P



