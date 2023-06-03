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
P.img       = "assets/img/npc/punit.png"
P.portrait  = "assets/img/npc/punit_portrait.png"
P.x         = 480
P.y         = 704
P.width     = 48
P.height    = 48
P.ox        = -24
P.oy        = -42
P.vx        = 33
P.vy        = 33



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
--          {"msg1", "msg2", "msg3"},  Random options for message 1
--          {"msg"},                   Single message for message 2
--          ...
--      }
--  C.nextid    Next conversation set
--  C.options   Options tables
--      {
--          {
--              ["text"]   = "name"    Name of option
--              ["nextid"] = id        ID of next conversation set upon selection
--          },
--          ...
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
        --"Hello",
        --"Hi",
        --"Hey",
        --"Sup",
        --"Hey there",
        --"How goes it",
        "I have been instructed to speak with you at length and with much verbosity to test font rendering and all that stuff so that is what we are going to do today and I really hope that it looks good on your monitor as well as mine"
    }
)
C.hello.stop = true

--  Goodbye
C.goodbye         = {}
C.goodbye.msgs    = {}
table.insert(
    C.goodbye.msgs,
    {
        "Bye Felicia",
        "Seeya later then",
        "You do you boo",
        "K",
        "Come find me if you change your mind",
        "Alright then",
        "Please reconsider",
    }
)
C.goodbye.stop    = true

--  Buy items intro
C.buy        = {}
C.buy.msgs   = {}
table.insert(
    C.buy.msgs,
    {
        "Today is your lucky day",
        "Looks like you found some coins",
        "Buy something will ya",
        "Khajit has wares if you have coin",
    }
)
table.insert(
    C.buy.msgs,
    {
        "Check this out",
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
        "I will sell you this mysterious key for 50 coins",
        "I will sell you this key I found for 50c",
        "I found this mysterious key and I am willing to part with it for 50c",
    }
)
C.buyYN.options     = {}
table.insert(
    C.buyYN.options,
    {
        ["text"]     = "no",
        ["nextid"]   = "goodbye",
    }
)
table.insert(
    C.buyYN.options,
    {
        ["text"]     = "yes",
        ["nextid"]   = "buyThanks",
    }
)

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
        "Fanks bruv",
        "Thanks lol",
        "Thank you very much",
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


--
--  Add conversations to NPC
--
P.conversation = C



return P



