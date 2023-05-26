--
--  Character data
--
local P = {}



--
--  Properties
--
P.path   = "assets/img/character/paul.png"
P.x      = 128
P.y      = 128
P.width  = 48
P.height = 48
P.ox     = -24
P.oy     = -42
P.vx     = 75
P.vy     = 75



--
--  Collider info
--
P.colliderInfo = {
    ["x"]      = P.x + math.floor(math.abs(P.ox) / 2),
    ["y"]      = P.y - math.abs(P.oy),
    ["width"]  = 24,
    ["height"] = 24,
    ["cutoff"] = 10
}


--
--  Directions (ie spritesheet row)
--
P.facing = {
    ["down"]  = 1,
    ["up"]    = 2,
    ["left"]  = 3,
    ["right"] = 4
}



--
--  Actions
--
P.actions = {
    ["default"] = {
        ["frames"] = "1-1",
        ["delay"]  = 1
    },
    ["walk"] = {
        ["frames"] = "2-5",
        ["delay"]  = 0.25
    }
}



return P



