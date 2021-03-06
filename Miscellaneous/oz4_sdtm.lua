--[[
------------------------------------
Script Name: {ØZ}-4 Snipers Dream Team Mod

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.12.0.0"
tbag = { }
weapon = { }
weapons = { }
objects = { }
players = { }
teleports = { }
flag_bool = { }
victim_coords = { }
crouch = { }
globals = nil
weapons[1] = {"weap", "weapons\\pistol\\pistol", true}
weapons[2] = {"weap", "weapons\\sniper rifle\\sniper rifle", true}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPreSpawn")
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if(gp == 3) then return end
    globals = read_dword(gp)
    InitSettings()
    for i = 1, 16 do
        if player_present(i) then
            players[get_var(i, "$n")].flag_captures = 0
            tbag[i] = { }
        end
    end
end

function OnScriptUnload()
    weapons = { }
end

function OnNewGame()
    InitSettings()
    mapname = get_var(1, "$map")
    for i = 1, #objects do
        if objects[i] ~= nil then
            local object = spawn_object(objects[i][1], objects[i][2], objects[i][3], objects[i][4], objects[i][5], objects[i][7])
        end
    end
    for i = 1, 16 do
        if player_present(i) then
            players[get_var(i, "$n")].flag_captures = 0
            tbag[i] = { }
        end
    end
end

function OnGameEnd()
    game_over = true
    for i = 1, 16 do
        if player_present(i) then
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            for j = 1, #teleports[mapname] do
                if teleports[mapname][j] ~= nil then
                    local player = get_dynamic_player(i)
                    if player ~= 0 then
                        if getPlayerCoords(i, teleports[mapname][j][1], teleports[mapname][j][2], teleports[mapname][j][3], teleports[mapname][j][4]) == true then
                            write_vector3d(player + 0x5C, teleports[mapname][j][5], teleports[mapname][j][6], teleports[mapname][j][7] + 0.3)
                        end
                    end
                end
            end
        end
    end
    for k = 1, 16 do
        if (player_alive(k)) then
            local player = get_dynamic_player(k)
            if (weapon[k] == false) then
                execute_command("wdel " .. k)
                local x, y, z = read_vector3d(player + 0x5C)
                for i = 1,#weapons do
                    if weapons[i][3] == true then
                        assign_weapon(spawn_object(weapons[i][1], weapons[i][2], x, y, z), k)
                    end
                end
                weapon[k] = true
            end
        end
    end
    for m = 1, 16 do
        if (player_alive(m)) then
            if get_var(m, "$team") == "red" then 
                if CheckBlueFlag(m) == true and flag_bool[m] then
                    if getPlayerCoords(m, 95.688, -159.449, -0.100, 1) then
                        say_all(get_var(m, "$name") .. " scored a flag for the red team!")
                        players[get_var(m, "$n")].flag_captures = players[get_var(m, "$n")].flag_captures + 1
                        rprint(m, "You have " .. tonumber(math.floor(players[get_var(m, "$n")].flag_captures)) .. " flag captures!")
                    end
                end
            elseif get_var(m, "$team") == "blue" then 
                if CheckRedFlag(m) == true and flag_bool[m] then
                    if getPlayerCoords(m, 40.241, -79.123, -0.100, 1) then
                        say_all(get_var(m, "$name") .. " scored a flag for the blue team!")
                        players[get_var(m, "$n")].flag_captures = players[get_var(m, "$n")].flag_captures + 1
                        rprint(m, "You have " .. tonumber(math.floor(players[get_var(m, "$n")].flag_captures)) .. " flag captures!")
                    end
                end
            end
            if (CheckBlueFlag(m) and flag_bool[m] == nil) then
                flag_bool[m] = true
                say_all(get_var(m, "$name") .. " has the blue teams flag!")
            elseif (CheckRedFlag(m) and flag_bool[m] == nil) then
                flag_bool[m] = true
                say_all(get_var(m, "$name") .. " has the red teams flag!")
            else
                execute_command("s " .. m .. " 1")
            end
        end
    end
    for n = 1, 16 do
        if player_present(n) then
            if tbag[n] == nil then tbag[n] = { } end
            if tbag[n].name and tbag[n].x then
                if not PlayerInVehicle(n) then
                    if getPlayerCoords(n, tbag[n].x, tbag[n].y, tbag[n].z, 5) then
                        local player_object = get_dynamic_player(n)
                        local obj_crouch = read_byte(player_object + 0x2A0)
                        local id = get_var(n, "$n")
                        if obj_crouch == 3 and crouch[id] == nil then
                            crouch[id] = OnPlayerCrouch(n)
                        elseif obj_crouch ~= 3 and crouch[id] ~= nil then
                            crouch[id] = nil
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].flag_captures = 0
    tbag[PlayerIndex] = { }
end

function OnPlayerPreSpawn(PlayerIndex)
    
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = false
end

function OnPlayerLeave(PlayerIndex)
    
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    if (killer > 0) and (victim ~= killer) then
        tbag[victim] = { }
        tbag[killer] = { }
        tbag[killer].count = 0
        tbag[killer].name = get_var(victim, "$name")
        if victim_coords[victim] == nil then victim_coords[victim] = { } end
        if victim_coords[victim].x then
            tbag[killer].x = victim_coords[victim].x
            tbag[killer].y = victim_coords[victim].y
            tbag[killer].z = victim_coords[victim].z
        end
    end
end

function OnPlayerCrouch(PlayerIndex)
    if tbag[PlayerIndex].count == nil then
        tbag[PlayerIndex].count = 0
    end
    tbag[PlayerIndex].count = tbag[PlayerIndex].count + 1
    if tbag[PlayerIndex].count == 4 then
        tbag[PlayerIndex].count = 0
        say_all(get_var(PlayerIndex, "$name") .. " is t-bagging " .. tbag[PlayerIndex].name)
        tbag[PlayerIndex].name = nil
    end
    return true
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if MapID == TagInfo("proj", "weapons\\sniper rifle\\sniper bullet") then
        return true, TagInfo("proj", "vehicles\\scorpion\\tank shell")
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- Prevent Tank Shell explosion suicide
    if PlayerIndex == CauserIndex then
        if (MetaID == VEHICLE_TANK_SHELL_EXPLOSION) then
            return true, Damage * 0
        end
    end
    -- Pistol Bullet Projectile
    if (MetaID == PISTOL_BULLET) then
        return true, Damage * 4
    end
    -- Sniper Rifle Projectile
    if (MetaID == SNIPER_RIFLE_BULLET) then
        return true, Damage * 4
    end
    -- Rocket Projectile / Rhog Rocket
    if (MetaID == ROCKET_EXPLODE) then
        if PlayerInVehicle(PlayerIndex) then
            return true, Damage * 4
        else
            return true, Damage * 4
        end
    end
    -- Ghost Bolt Damage --
    if (MetaID == VEHICLE_GHOST_BOLT) then
        return true, Damage * 4
    end
    -- Warthog Bullet Damage --
    if (MetaID == WARTHOG_BULLET) then
        return true, Damage * 4
    end
    -- Tank Shell Damage --
    if (MetaID == VEHICLE_TANK_SHELL) then
        return true, Damage * 4
    end
    -- Tank Bullet Damage --
    if (MetaID == VEHICLE_TANK_BULLET) then
        return true, Damage * 4
    end
    -- Banshee Bolt Damage --
    if (MetaID == VEHICLE_BANSHEE_BOLT) then
        return true, Damage * 4
    end
    -- Banshee Fuelrod Damage --
    if (MetaID == VEHICLE_BANSHEE_FUEL_ROD) then
        return true, Damage * 4
    end
    -- Grenade Damage --
    if (MetaID == FRAG_EXPLOSION) or(MetaID == FRAG_SHOCKWAVE) or(MetaID == PLASMA_ATTACHED) or(MetaID == PLASMA_EXPLOSION) or(MetaID == PLASMA_SHOCKWAVE) then
        return true, Damage * 4
    end
    -- Melee Damage --
    if (MetaID == MELEE_PISTOL) or(MetaID == MELEE_SNIPER_RIFLE) then
        return true, Damage * 4
    end
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object then
        local x, y, z = read_vector3d(player_object + 0x5C)
        if victim_coords[PlayerIndex] == nil then
            victim_coords[PlayerIndex] = { }
        end
        if victim_coords[PlayerIndex] then
            victim_coords[PlayerIndex].x = x
            victim_coords[PlayerIndex].y = y
            victim_coords[PlayerIndex].z = z
        end
    end
end

function CheckRedFlag(PlayerIndex)
    local red_flag = read_dword(globals + 0x8)
    for i=0,3 do
        local object = read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 + 4 * i)
        if (object == red_flag) then return true end
    end
    return false
end

function CheckBlueFlag(PlayerIndex)
    local blue_flag = read_dword(globals + 0xC)
    for i=0,3 do
        local object = read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 + 4 * i)
        if (object == blue_flag) then return true end
    end
    return false
end

function InitSettings()
    execute_command("scorelimit 50")
    objects = {
        -- blue vehicles
        { "vehi", "vehicles\\banshee\\banshee_mp", 70.078, - 62.626, 3.758,                 "Blue Banshee", 10 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 29.544, - 53.628, 3.302,       "Blue Turret", 124.5 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 23.598, -102.343, 2.163,               "Blue Tank [Ramp]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 38.119, -64.898, 0.617,                "Blue Tank [Immediate Rear of Base]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 51.349, -61.517, 1.759,                "Blue Tank [Rear-Right of Base]", 90 },
        { "vehi", "vehicles\\rwarthog\\rwarthog", 50.655, -87.787, 0.079,                   "Blue Rocket Hog [Front-Right of Base]", -90 },
        { "vehi", "vehicles\\rwarthog\\rwarthog", 62.745, -72.406, 1.031,                   "Blue Rocket Hog [Far-Right of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 28.854, -90.193, 0.434,                  "Blue Chain Gun Hog [Front-Left of Base]", 90 },
        
        -- red vehicles
        { "vehi", "vehicles\\banshee\\banshee_mp", 64.178, - 176.802, 3.960,                "Red Banshee", 120 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 118.084, - 185.346, 6.563,     "Red Turret", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 104.017, - 129.761, 1.665,             "Red Tank [Dark-Side]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 97.117, -173.132, 0.744,               "Red Tank [Immediate Rear of Base]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 81.150, -169.359, 0.158,               "Red Tank [Rear-Right of Base]", 90 },
        { "vehi", "vehicles\\rwarthog\\rwarthog", 106.885, -169.245, 0.091,                 "Red Rocket Hog [Left-Rear of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 67.961, -171.002, 1.428,                 "Red Chain Gun Hog [Far Right of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 102.312, -144.626, 0.580,                "Red Chain Gun Hog [Front-Left of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 43.559, -64.809, 1.113,                  "Red Chain Gun Hog [Immediate Rear of Base]", 90 },
        
        -- other vehicles
        { "vehi", "vehicles\\ghost\\ghost_mp", 59.294, - 116.212, 1.797,                    "Ghost [Mid-Field]", 90 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 51.315, - 154.075, 21.561,     "Cliff Turret", 90 },
        
        -- health packs [these designate portal locations]
        { "eqip", "powerups\\health pack", 37.070, - 80.068, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 37.105, - 78.421, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 43.144, - 78.442, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 43.136, - 80.072, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 43.512, - 77.153, - 0.286, "health pack - bluebase", 90},
        
        { "eqip", "powerups\\health pack", 98.930, - 157.614, - 0.249, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 98.498, - 158.564, - 0.228, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 98.508, - 160.189, - 0.228, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 92.555, - 160.193, - 0.228, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 92.560, - 158.587, - 0.228, "health pack - redbase", 90}
        
        -- { "eqip", "powerups\\health pack", 74.391, - 77.651, 5.698, "health pack - blue path", 90},
        -- { "eqip", "powerups\\health pack", 70.650, - 61.932, 4.095, "health pack - blue banshee", 90},
        -- { "eqip", "powerups\\health pack", 63.551, - 177.337, 4.181, "health pack - red banshee", 90},
        -- { "eqip", "powerups\\health pack", 120.247, - 185.103, 6.495, "health pack - red turret", 90},
        -- { "eqip", "powerups\\health pack", 94.351, - 97.615, 5.184, "health pack - Rock between the caves", 90},
        -- { "eqip", "powerups\\health pack", 12.928, - 103.277, 13.990, "health pack - Nest", 90},
        -- { "eqip", "powerups\\health pack", 48.060, - 153.092, 21.190, "health pack - turret mountain", 90},
        -- { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920, "health pack - rear cliff (blue)", 90},
        -- { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920, "health pack - corner cliff (blue)", 90},
        -- { "eqip", "powerups\\health pack", 77.279, - 89.107, 22.571, "health pack - cliff (overlooking mid field)", 90},
        -- { "eqip", "powerups\\health pack", 101.034, - 117.048, 14.795, "health pack - platform (overlooking redbase)", 90},
        -- { "eqip", "powerups\\health pack", 118.244, - 120.757, 17.229, "cliff - overlooking red (banshee platform)", 90},
        -- { "eqip", "powerups\\health pack", 131.737, - 169.891, 15.870, "health pack - rear left-cliff (red)", 90},
        -- { "eqip", "powerups\\health pack", 121.011, - 188.595, 13.771, "health pack - rear right-cliff (red)", 90},
        -- { "eqip", "powerups\\health pack", 97.504, - 188.913, 15.784, "health pack - platform (behind red)", 90}
    }

    teleports["bloodgulch"] = {
        { 43.125, - 78.434, - 0.220,                0.5,    15.713, - 102.762, 13.462,      280, - 10, 0, "1"},
        { 43.112, - 80.069, - 0.253,                0.5,    68.123, - 92.847, 2.167,        280, - 10, 0 , "2"},
        { 37.105, - 80.069, - 0.255,                0.5,    108.005, - 109.328, 1.924,      280, - 10, 0 , "3"},
        { 37.080, - 78.426, - 0.238,                0.5,    79.924, - 64.560, 4.669,        280, - 10, 0 , "4"},
        { 43.456, - 77.197, 0.633,                  0.5,    29.528, - 52.746, 3.100,        280, - 10, 0 , "5"},
        { 74.304, - 77.590, 6.552,                  0.5,    76.001, - 77.936, 11.425,       280, - 10, 0 , "6"},
        { 98.559, - 158.558, - 0.253,               0.5,    63.338, - 169.305, 3.702,       280, - 10, 0 , "7"},
        { 98.541, - 160.190, - 0.255,               0.5,    120.801, - 182.946, 6.766,      280, - 10, 0 , "8"},
        { 92.550, - 158.581, - 0.256,               0.5,    46.934, - 151.024, 4.496,       280, - 10, 0 , "9"},
        { 92.538, - 160.213, - 0.215,               0.5,    112.550, - 127.203, 1.905,      280, - 10, 0 , "10"},
        { 98.935, - 157.626, 0.425,                 0.5,    95.725, - 91.968, 5.314,        280, - 10, 0 , "11"},
        { 70.499, - 62.119, 5.382,                  0.5,    122.615, - 123.520, 15.916,     280, - 10, 0 , "12"},
        { 63.693, - 177.303, 5.606,                 0.5,    19.030, - 103.428, 19.150,      280, - 10, 0 , "13"},
        { 120.616, - 185.624, 7.637,                0.5,    94.815, - 114.354, 15.860,      280, - 10, 0 , "14"},
        { 94.351, - 97.615, 5.184,                  0.5,    92.792, - 93.604, 9.501,        280, - 10, 0 , "15"},
        { 14.852, - 99.241, 8.995,                  0.5,    50.409, - 155.826, 21.830,      280, - 10, 0 , "16"},
        { 43.258, - 45.365, 20.901,                 0.5,    82.065, - 68.507, 18.152,       280, - 10, 0 , "17"},
        { 82.459, - 73.877, 15.729,                 0.5,    67.970, - 86.299, 23.393,       280, - 10, 0 , "18"},
        { 77.289, - 89.126, 22.765,                 0.5,    94.772, - 114.362, 15.820,      280, - 10, 0 , "19"},
        { 101.224, - 117.028, 14.884,               0.5,    125.026, - 135.580, 13.593,     280, - 10, 0 , "20"},
        { 131.785, - 169.872, 15.951,               0.5,    127.812, - 184.557, 16.420,     280, - 10, 0 , "21"},
        { 120.665, - 188.766, 13.752,               0.5,    109.956, - 188.522, 14.437,     280, - 10, 0 , "22"},
        { 97.476, - 188.912, 15.718,                0.5,    53.653, - 157.885, 21.753,      280, - 10, 0 , "23"},
        { 48.046, - 153.087, 21.181,                0.5,    23.112, - 59.428, 16.352,       280, - 10, 0 , "24"},
        { 118.263, - 120.761, 17.192,               0.5,    40.194, - 139.990, 2.733,       280, - 10, 0 , "25"},
    }
    
    -- Melee --
    MELEE_PISTOL = TagInfo("jpt!", "weapons\\pistol\\melee")
    MELEE_SNIPER_RIFLE = TagInfo("jpt!", "weapons\\sniper rifle\\melee")
    -- Grenades Explosion/Attached --
    FRAG_EXPLOSION = TagInfo("jpt!", "weapons\\frag grenade\\explosion")
    FRAG_SHOCKWAVE = TagInfo("jpt!", "weapons\\frag grenade\\shock wave")
    PLASMA_ATTACHED = TagInfo("jpt!", "weapons\\plasma grenade\\attached")
    PLASMA_EXPLOSION = TagInfo("jpt!", "weapons\\plasma grenade\\explosion")
    PLASMA_SHOCKWAVE = TagInfo("jpt!", "weapons\\plasma grenade\\shock wave")
    -- Vehicles --
    WARTHOG_BULLET = TagInfo("proj", "vehicles\\warthog\\bullet")
    VEHICLE_GHOST_BOLT = TagInfo("jpt!", "vehicles\\ghost\\ghost bolt")
    VEHICLE_TANK_BULLET = TagInfo("jpt!", "vehicles\\scorpion\\bullet")
    VEHICLE_TANK_SHELL = TagInfo("jpt!", "vehicles\\scorpion\\tank shell")
    VEHICLE_BANSHEE_BOLT = TagInfo("jpt!", "vehicles\\banshee\\banshee bolt")
    VEHICLE_BANSHEE_FUEL_ROD = TagInfo("jpt!", "vehicles\\banshee\\mp_banshee fuel rod")
    VEHICLE_TANK_SHELL_EXPLOSION = TagInfo("jpt!", "vehicles\\scorpion\\shell explosion")
    -- weapon projectiles --
    PISTOL_BULLET = TagInfo("jpt!", "weapons\\pistol\\bullet")
    SNIPER_RIFLE_BULLET = TagInfo("jpt!", "weapons\\sniper rifle\\sniper bullet")
    ROCKET_EXPLODE = TagInfo("jpt!", "weapons\\rocket launcher\\explosion")
    local red_flag = read_dword(globals + 0x8)
    local blue_flag = read_dword(globals + 0xC)
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        local tag_data = read_dword(tag + 0x14)
        -- Changes proj velocity of grenades
        if (tag_class == 1651077220 and tag_name == "characters\\cyborg_mp\\cyborg_mp") then
            write_dword(tag_data + 0x2c0, 1097859072)
        end
        -- weapons\pistol\pistol.weap
        if(tag_class == 2003132784 and tag_name == "weapons\\pistol\\pistol") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x71c, 34340864)
            write_dword(tag_data + 0x720, 1573114)
            write_dword(tag_data + 0x730, 24)
            write_dword(tag_data + 0x7a8, 1103626240)
            write_dword(tag_data + 0x7ac, 1103626240)
            write_dword(tag_data + 0x7c4, 0)
        end
        -- weapons\pistol\bullet.proj
        if(tag_class == 1886547818 and tag_name == "weapons\\pistol\\bullet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1c8, 1148846080)
            write_dword(tag_data + 0x1e4, 1097859072)
            write_dword(tag_data + 0x1e8, 1097859072)
        end
        -- weapons\pistol\bullet.jpt!
        if(tag_class == 1785754657 and tag_name == "weapons\\pistol\\bullet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1133903872)
            write_dword(tag_data + 0x1d4, 1133903872)
            write_dword(tag_data + 0x1d8, 1133903872)
            write_dword(tag_data + 0x1ec, 1041865114)
            write_dword(tag_data + 0x1f4, 1073741824)
        end
        -- vehicles\scorpion\tank shell.proj
        if(tag_class == 1886547818 and tag_name == "vehicles\\scorpion\\tank shell") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1e4, 1114636288)
            write_dword(tag_data + 0x1e8, 1114636288)
        end
        -- vehicles\scorpion\shell explosion.jpt!
        if(tag_class == 1785754657 and tag_name == "vehicles\\scorpion\\shell explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1073741824)
            write_dword(tag_data + 0x4, 1081081856)
            write_dword(tag_data + 0x1c8, 33)
            write_dword(tag_data + 0x1d0, 1131413504)
            write_dword(tag_data + 0x1f4, 1092091904)
        end
        -- weapons\frag grenade\shock wave.jpt!
        if(tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\shock wave") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0xd4, 1048576000)
            write_dword(tag_data + 0xd8, 1022739087)
        end
        -- weapons\frag grenade\explosion.jpt!
        if(tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1073741824)
            write_dword(tag_data + 0x4, 1083703296)
            write_dword(tag_data + 0x34, 1061158912)
            write_dword(tag_data + 0xd4, 1011562294)
            write_dword(tag_data + 0x1c8, 41)
            write_dword(tag_data + 0x1d0, 1131413504)
            write_dword(tag_data + 0x1d4, 1135575040)
            write_dword(tag_data + 0x1d8, 1135575040)
            write_dword(tag_data + 0x1f4, 1092091904)
        end
        -- weapons\sniper rifle\sniper rifle.weap
        if(tag_class == 2003132784 and tag_name == "weapons\\sniper rifle\\sniper rifle") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x3e8, 1128792064)
            write_dword(tag_data + 0x3f0, 1128792064)
            write_dword(tag_data + 0x894, 7340032)
            write_dword(tag_data + 0x898, 786532)
            write_dword(tag_data + 0x8a8, 12)
            write_dword(tag_data + 0x920, 1075838976)
            write_dword(tag_data + 0x924, 1075838976)
        end
        -- weapons\sniper rifle\sniper bullet.proj
        if(tag_class == 1886547818 and tag_name == "weapons\\sniper rifle\\sniper bullet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x180, 65536)
            write_dword(tag_data + 0x1e4, 1114636288)
            write_dword(tag_data + 0x1e8, 1114636288)
        end
        -- weapons\plasma grenade\explosion.jpt!
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x4, 1086324736)
            write_dword(tag_data + 0x1c8, 41)
            write_dword(tag_data + 0x1d0, 1140457472)
            write_dword(tag_data + 0x1d4, 1140457472)
            write_dword(tag_data + 0x1d8, 1140457472)
            write_dword(tag_data + 0x1f4, 1094713344)
        end
        -- weapons\frag grenade\frag grenade.proj
        if(tag_class == 1886547818 and tag_name == "weapons\\frag grenade\\frag grenade") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1bc, 1050253722)
            write_dword(tag_data + 0x1c0, 1050253722)
            write_dword(tag_data + 0x1cc, 1057803469)
        end
        -- weapons\plasma grenade\plasma grenade.proj
        if(tag_class == 1886547818 and tag_name == "weapons\\plasma grenade\\plasma grenade") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1bc, 1065353216)
            write_dword(tag_data + 0x1c0, 1065353216)
            write_dword(tag_data + 0x1cc, 1056964608)
        end
        -- weapons\plasma grenade\attached.jpt!
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\attached") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1137180672)
            write_dword(tag_data + 0x1d4, 1137180672)
            write_dword(tag_data + 0x1d8, 1137180672)
            write_dword(tag_data + 0x1f4, 1092616192)
        end
        break
    end
end

function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function getPlayerCoords(PlayerIndex, posX, posY, posZ, radius)
    local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
    if (posX - x) ^ 2 + (posY - y) ^ 2 + (posZ - z) ^ 2 <= radius then
        return true
    else
        return false
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
