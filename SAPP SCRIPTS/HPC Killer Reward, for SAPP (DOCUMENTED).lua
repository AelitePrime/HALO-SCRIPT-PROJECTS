--[[
    ------------------------------------
Script Name: HPC Killer Reward, for SAPP (DOCUMENTED)
    - Implementing API version: 1.11.0.0

Description: This script will drop a random item from an EQUIPMENT TABLE at the victims death location.


*** DOCUMENTATION ***
    - If you would prefer to view a UN-documented version of this script, please visit:
    https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/SAPP%20SCRIPTS/HPC%20Killer%20Reward%2C%20for%20SAPP%20(UNDOCUMENTED).lua


-- Five Settings available:

[1] BasedOnMap
[2] BasedOnGameType
[3] NonGlobalKillsRequired
[4] GlobalSettings
[5] GlobalNoKills

    Currently, settings [1] and [2] cannot be used in conjunction with global settings.
    Settings [1] and [2] are used independently. This might change in a future [enhancement] update.

    ** IMPORTANT **
    -   In order to use global settings, you must have NonGlobalKillsRequired set to false.
    -   Global Settings do not take into account the gametype or map.

    * BasedOnMap:           Script will pull random items from the MAP EQUIPMENT TABLE.
    * BasedOnGameType:      Script will pull random items from the GAMETYPE EQUIPMENT TABLE.
    * GlobalSettings:       Script will pull random items from the GLOBAL EQUIPMENT TABLE
    * GlobalNoKills:        Toggle on\off required-kill-threshold

    The current configuration of this script is set up so the 'Killer' has to reach a required kill-threshold in order for his victim to
    drop an item from (global) EQUIPMENT_TABLE drop table.

    You can turn on|off (true/false) a setting called 'GlobalNoKills'.

    - If true, the Killer will have to reach 10 kills first, and only then will his victim drop an item.
    - Then after 20 kills, his victim will drop another item and so on.
    - You can change these values in the OnPlayerDeath function.

    If 'GlobalNoKills' is set to "false", the victim will indefinitely drop an item from the GLOBAL EQUIPMENT TABLE.
    - GlobalNoKills cannot be used in conjunction with BasedOnMap, and BasedOnGameType.


    true = Enabled
    false = Disabled


Copyright � 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

BasedOnMap = false
BasedOnGameType = false
NonGlobalKillsRequired = false
-- Global Settings do not take into account the gametype or map.
GlobalSettings = true
GlobalNoKills = true
-- For a future update!
WeaponAndEquipment = false

-- Do Not Touch!
weap = "weap"
eqip = "eqip"
GameHasStarted = false
VICTIM_LOCATION = { }
for i = 1, 16 do VICTIM_LOCATION[i] = { } end

-- =====================================================================================================--

-- Global Settings --
GLOBAL_EQUIPMENT_TABLE = { }
GLOBAL_EQUIPMENT_TABLE[1] = "powerups\\active camouflage"
GLOBAL_EQUIPMENT_TABLE[2] = "powerups\\health pack"
GLOBAL_EQUIPMENT_TABLE[3] = "powerups\\over shield"
GLOBAL_EQUIPMENT_TABLE[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GLOBAL_EQUIPMENT_TABLE[5] = "powerups\\needler ammo\\needler ammo"
GLOBAL_EQUIPMENT_TABLE[6] = "powerups\\pistol ammo\\pistol ammo"
GLOBAL_EQUIPMENT_TABLE[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GLOBAL_EQUIPMENT_TABLE[8] = "powerups\\shotgun ammo\\shotgun ammo"
GLOBAL_EQUIPMENT_TABLE[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GLOBAL_EQUIPMENT_TABLE[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

GLOBAL_WEAPON_TABLE = { }
GLOBAL_WEAPON_TABLE[1] = "weapons\\assault rifle\\assault rifle"
GLOBAL_WEAPON_TABLE[2] = "weapons\\flamethrower\\flamethrower"
GLOBAL_WEAPON_TABLE[3] = "weapons\\needler\\mp_needler"
GLOBAL_WEAPON_TABLE[4] = "weapons\\pistol\\pistol"
GLOBAL_WEAPON_TABLE[5] = "weapons\\plasma pistol\\plasma pistol"
GLOBAL_WEAPON_TABLE[6] = "weapons\\plasma rifle\\plasma rifle"
GLOBAL_WEAPON_TABLE[7] = "weapons\\plasma_cannon\\plasma_cannon"
GLOBAL_WEAPON_TABLE[8] = "weapons\\rocket launcher\\rocket launcher"
GLOBAL_WEAPON_TABLE[9] = "weapons\\shotgun\\shotgun"
GLOBAL_WEAPON_TABLE[10] = "weapons\\sniper rifle\\sniper rifle"
---------------------------------------------------------------------------------------------------------
MAP_EQ_TABLE_BEAVERCREEK = { }
MAP_EQ_TABLE_BEAVERCREEK[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_BEAVERCREEK[2] = "powerups\\health pack"
MAP_EQ_TABLE_BEAVERCREEK[3] = "powerups\\over shield"
MAP_EQ_TABLE_BEAVERCREEK[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_BEAVERCREEK[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_BEAVERCREEK[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_BEAVERCREEK[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_BEAVERCREEK[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_BEAVERCREEK[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_BEAVERCREEK[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_BLOODGULCH = { }
MAP_EQ_TABLE_BLOODGULCH[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_BLOODGULCH[2] = "powerups\\health pack"
MAP_EQ_TABLE_BLOODGULCH[3] = "powerups\\over shield"
MAP_EQ_TABLE_BLOODGULCH[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_BLOODGULCH[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_BLOODGULCH[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_BLOODGULCH[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_BLOODGULCH[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_BLOODGULCH[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_BLOODGULCH[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_BOARDINGACTION = { }
MAP_EQ_TABLE_BOARDINGACTION[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_BOARDINGACTION[2] = "powerups\\health pack"
MAP_EQ_TABLE_BOARDINGACTION[3] = "powerups\\over shield"
MAP_EQ_TABLE_BOARDINGACTION[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_BOARDINGACTION[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_BOARDINGACTION[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_BOARDINGACTION[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_BOARDINGACTION[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_BOARDINGACTION[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_BOARDINGACTION[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_CAROUSEL = { }
MAP_EQ_TABLE_CAROUSEL[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_CAROUSEL[2] = "powerups\\health pack"
MAP_EQ_TABLE_CAROUSEL[3] = "powerups\\over shield"
MAP_EQ_TABLE_CAROUSEL[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_CAROUSEL[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_CAROUSEL[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_CAROUSEL[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_CAROUSEL[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_CAROUSEL[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_CAROUSEL[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_CHILLOUT = { }
MAP_EQ_TABLE_CHILLOUT[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_CHILLOUT[2] = "powerups\\health pack"
MAP_EQ_TABLE_CHILLOUT[3] = "powerups\\over shield"
MAP_EQ_TABLE_CHILLOUT[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_CHILLOUT[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_CHILLOUT[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_CHILLOUT[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_CHILLOUT[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_CHILLOUT[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_CHILLOUT[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_DAMNATION = { }
MAP_EQ_TABLE_DAMNATION[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_DAMNATION[2] = "powerups\\health pack"
MAP_EQ_TABLE_DAMNATION[3] = "powerups\\over shield"
MAP_EQ_TABLE_DAMNATION[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_DAMNATION[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_DAMNATION[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_DAMNATION[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_DAMNATION[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_DAMNATION[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_DAMNATION[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_DANGERCANYON = { }
MAP_EQ_TABLE_DANGERCANYON[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_DANGERCANYON[2] = "powerups\\health pack"
MAP_EQ_TABLE_DANGERCANYON[3] = "powerups\\over shield"
MAP_EQ_TABLE_DANGERCANYON[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_DANGERCANYON[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_DANGERCANYON[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_DANGERCANYON[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_DANGERCANYON[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_DANGERCANYON[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_DANGERCANYON[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_DEATHISLAND = { }
MAP_EQ_TABLE_DEATHISLAND[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_DEATHISLAND[2] = "powerups\\health pack"
MAP_EQ_TABLE_DEATHISLAND[3] = "powerups\\over shield"
MAP_EQ_TABLE_DEATHISLAND[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_DEATHISLAND[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_DEATHISLAND[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_DEATHISLAND[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_DEATHISLAND[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_DEATHISLAND[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_DEATHISLAND[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_GEPHYROPHOBIA = { }
MAP_EQ_TABLE_GEPHYROPHOBIA[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_GEPHYROPHOBIA[2] = "powerups\\health pack"
MAP_EQ_TABLE_GEPHYROPHOBIA[3] = "powerups\\over shield"
MAP_EQ_TABLE_GEPHYROPHOBIA[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_HANGEMHIGH = { }
MAP_EQ_TABLE_HANGEMHIGH[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_HANGEMHIGH[2] = "powerups\\health pack"
MAP_EQ_TABLE_HANGEMHIGH[3] = "powerups\\over shield"
MAP_EQ_TABLE_HANGEMHIGH[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_HANGEMHIGH[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_HANGEMHIGH[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_HANGEMHIGH[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_HANGEMHIGH[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_HANGEMHIGH[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_HANGEMHIGH[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_ICEFIELDS = { }
MAP_EQ_TABLE_ICEFIELDS[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_ICEFIELDS[2] = "powerups\\health pack"
MAP_EQ_TABLE_ICEFIELDS[3] = "powerups\\over shield"
MAP_EQ_TABLE_ICEFIELDS[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_ICEFIELDS[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_ICEFIELDS[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_ICEFIELDS[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_ICEFIELDS[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_ICEFIELDS[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_ICEFIELDS[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_INFINITY = { }
MAP_EQ_TABLE_INFINITY[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_INFINITY[2] = "powerups\\health pack"
MAP_EQ_TABLE_INFINITY[3] = "powerups\\over shield"
MAP_EQ_TABLE_INFINITY[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_INFINITY[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_INFINITY[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_INFINITY[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_INFINITY[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_INFINITY[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_INFINITY[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_LONGEST = { }
MAP_EQ_TABLE_LONGEST[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_LONGEST[2] = "powerups\\health pack"
MAP_EQ_TABLE_LONGEST[3] = "powerups\\over shield"
MAP_EQ_TABLE_LONGEST[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_LONGEST[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_LONGEST[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_LONGEST[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_LONGEST[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_LONGEST[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_LONGEST[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_PRISONER = { }
MAP_EQ_TABLE_PRISONER[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_PRISONER[2] = "powerups\\health pack"
MAP_EQ_TABLE_PRISONER[3] = "powerups\\over shield"
MAP_EQ_TABLE_PRISONER[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_PRISONER[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_PRISONER[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_PRISONER[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_PRISONER[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_PRISONER[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_PRISONER[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_PUTPUT = { }
MAP_EQ_TABLE_PUTPUT[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_PUTPUT[2] = "powerups\\health pack"
MAP_EQ_TABLE_PUTPUT[3] = "powerups\\over shield"
MAP_EQ_TABLE_PUTPUT[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_PUTPUT[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_PUTPUT[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_PUTPUT[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_PUTPUT[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_PUTPUT[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_PUTPUT[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_RATRACE = { }
MAP_EQ_TABLE_RATRACE[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_RATRACE[2] = "powerups\\health pack"
MAP_EQ_TABLE_RATRACE[3] = "powerups\\over shield"
MAP_EQ_TABLE_RATRACE[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_RATRACE[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_RATRACE[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_RATRACE[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_RATRACE[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_RATRACE[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_RATRACE[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_SIDEWINDER = { }
MAP_EQ_TABLE_SIDEWINDER[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_SIDEWINDER[2] = "powerups\\health pack"
MAP_EQ_TABLE_SIDEWINDER[3] = "powerups\\over shield"
MAP_EQ_TABLE_SIDEWINDER[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_SIDEWINDER[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_SIDEWINDER[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_SIDEWINDER[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_SIDEWINDER[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_SIDEWINDER[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_SIDEWINDER[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_TIMBERLAND = { }
MAP_EQ_TABLE_TIMBERLAND[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_TIMBERLAND[2] = "powerups\\health pack"
MAP_EQ_TABLE_TIMBERLAND[3] = "powerups\\over shield"
MAP_EQ_TABLE_TIMBERLAND[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_TIMBERLAND[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_TIMBERLAND[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_TIMBERLAND[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_TIMBERLAND[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_TIMBERLAND[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_TIMBERLAND[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_WIZARD = { }
MAP_EQ_TABLE_WIZARD[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_WIZARD[2] = "powerups\\health pack"
MAP_EQ_TABLE_WIZARD[3] = "powerups\\over shield"
MAP_EQ_TABLE_WIZARD[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_WIZARD[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_WIZARD[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_WIZARD[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_WIZARD[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_WIZARD[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_WIZARD[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

GAMETYPE_EQ_TABLE_CTF = { }
GAMETYPE_EQ_TABLE_CTF[1] = "powerups\\active camouflage"
GAMETYPE_EQ_TABLE_CTF[2] = "powerups\\health pack"
GAMETYPE_EQ_TABLE_CTF[3] = "powerups\\over shield"
GAMETYPE_EQ_TABLE_CTF[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_TABLE_CTF[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_TABLE_CTF[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_TABLE_CTF[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_TABLE_CTF[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_TABLE_CTF[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_TABLE_CTF[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

GAMETYPE_EQ_TABLE_SLAYER = { }
GAMETYPE_EQ_TABLE_SLAYER[1] = "powerups\\active camouflage"
GAMETYPE_EQ_TABLE_SLAYER[2] = "powerups\\health pack"
GAMETYPE_EQ_TABLE_SLAYER[3] = "powerups\\over shield"
GAMETYPE_EQ_TABLE_SLAYER[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_TABLE_SLAYER[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_TABLE_SLAYER[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_TABLE_SLAYER[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_TABLE_SLAYER[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_TABLE_SLAYER[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_TABLE_SLAYER[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

function LoadMaps()
    if GameHasStarted then
        mapnames = {
            "beavercreek",
            "bloodgulch",
            "boardingaction",
            "carousel",
            "chillout",
            "damnation",
            "dangercanyon",
            "deathisland",
            "gephyrophobia",
            "hangemhigh",
            "icefields",
            "infinity",
            "longest",
            "prisoner",
            "putput",
            "ratrace",
            "sidewinder",
            "timberland",
            "wizard"
        }
        map_name = get_var(1, "$map")
        mapnames[map_name] = mapnames[map_name] or false
    end
end

function OnScriptLoad()
    -- >> register_callback: This function registers a function that will be called every time the event is called.
    -- >> You may only have one function registered per event.
    -- >> Callback IDs are in the cb global variable and are retrieved using cb[�EVENT_ID�].
    -- >> Ref: http://halo.isimaginary.com/lua_info/#register_callback
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    -- >> This function retrieves an event variable, or a custom variable set by var_add.
    -- >> Ref: http://halo.isimaginary.com/lua_info/#get_var
    if get_var(0, "$gt") ~= "n/a" then
        GameHasStarted = true
        map_name = get_var(1, "$map")
        game_type = get_var(0, "$gt")
        LoadMaps()
    end
end

function OnScriptUnload() end

function OnNewGame()
    -- Do Not Touch!
    GameHasStarted = true
end

function OnGameEnd()
    -- Do Not Touch!
    GameHasStarted = false
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    -- victim = Victim? (Player who died).
    local victim = tonumber(VictimIndex)
    -- killer = Killer? (Player whom killed the Victim - RIP!!).
    local killer = tonumber(KillerIndex)
    -- victimName = retrieves victim's Name
    local victimName = tostring(get_var(victim, "$name"))
    -- kills = retrieves the value of how many kills the Killer has under their belt, (so-to-speak).
    local kills = tonumber(get_var(killer, "$kills"))
    -- >> Gets the player's object if the player is alive.
    -- >> Ref: http://halo.isimaginary.com/lua_info/#get_dynamic_player
    local player_object = get_dynamic_player(victim)

    -- Suicide
    if killer == victim then
        return false
        -- Killed by Vehicle
    elseif (killer == 0) then
        return false
        -- Killed by Server
    elseif (killer == -1) then
        return false
        -- Killer is unknown
    elseif (killer == nil) then
        return false
    end

    if GameHasStarted then
        if NonGlobalKillsRequired == true then
            -- Check if killer and victim are valid.
            if killer and victim ~= nil then
                -- Killed by another player.
                if (killer > 0) then
                    -- Equal to 10 Kills.
                    if (kills == 10) then
                        -- >> Get victim Coordinates.
                        -- >> Reads three 32-bit floats. This function retrieves three single-precision floating point numbers, or nil if failed
                        -- >> Ref: http://halo.isimaginary.com/lua_info/#read_vector3d
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                    elseif (kills == 20) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 30) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 40) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 50) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 60) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 70) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 80) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 90) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)
                        -- Equal to or greater than 100 kills.
                    elseif (kills >= 100) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)
                    end
                end
            end
            -- Kills NOT Required, and uses Global Equipment Table (does not take into account the gametype or map)
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == true then
            if (killer > 0) then
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                math.randomseed(os.time())
                -- pick 1 of (up to 20) random items from the respective table.
                local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local eqTable = math.random(1, 2)
                if (tonumber(eqTable) == 1) then
                    -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                    -- >> This function spawns an object at the specified coordiantes.
                    -- >> If TagID is specified, then TagType and TagPath are not read and effectively become optional arguments.
                    -- >> It will return the Object ID of the spawned object.
                    -- >> Ref: http://halo.isimaginary.com/lua_info/#spawn_object
                    spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                elseif (tonumber(eqTable) == 2) then
                    spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                end
            end
            -- Kills Required, and uses Global Equipment Table (does not take into account the gametype or map)
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == false then
            if (killer > 0) then
                if (kills == 10) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 20) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 30) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 40) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 50) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 60) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 70) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 80) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 90) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills >= 100) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end
                end
            end
        end
    end
end

function DropTable(victim, x, y, z)

    -- Based On Map --
    if BasedOnMap == true and BasedOnGameType == false then
        -- Check if mapname is beavercreek
        if map_name == "beavercreek" then
            itemtoDrop = MAP_EQ_TABLE_BEAVERCREEK[math.random(0, #MAP_EQ_TABLE_BEAVERCREEK - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "bloodgulch" then
            itemtoDrop = MAP_EQ_TABLE_BLOODGULCH[math.random(0, #MAP_EQ_TABLE_BLOODGULCH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "boardingaction" then
            itemtoDrop = MAP_EQ_TABLE_BOARDINGACTION[math.random(0, #MAP_EQ_TABLE_BOARDINGACTION - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "carousel" then
            itemtoDrop = MAP_EQ_TABLE_CAROUSEL[math.random(0, #MAP_EQ_TABLE_CAROUSEL - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "chillout" then
            itemtoDrop = MAP_EQ_TABLE_CHILLOUT[math.random(0, #MAP_EQ_TABLE_CHILLOUT - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "damnation" then
            itemtoDrop = MAP_EQ_TABLE_DAMNATION[math.random(0, #MAP_EQ_TABLE_DAMNATION - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "dangercanyon" then
            itemtoDrop = MAP_EQ_TABLE_DANGERCANYON[math.random(0, #MAP_EQ_TABLE_DANGERCANYON - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "deathisland" then
            itemtoDrop = MAP_EQ_TABLE_DEATHISLAND[math.random(0, #MAP_EQ_TABLE_DEATHISLAND - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "gephyrophobia" then
            itemtoDrop = MAP_EQ_TABLE_GEPHYROPHOBIA[math.random(0, #MAP_EQ_TABLE_GEPHYROPHOBIA - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "hangemhigh" then
            itemtoDrop = MAP_EQ_TABLE_HANGEMHIGH[math.random(0, #MAP_EQ_TABLE_HANGEMHIGH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "icefields" then
            itemtoDrop = MAP_EQ_TABLE_ICEFIELDSE[math.random(0, #MAP_EQ_TABLE_ICEFIELDSE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "infinity" then
            itemtoDrop = MAP_EQ_TABLE_INFINITY[math.random(0, #MAP_EQ_TABLE_INFINITY - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "longest" then
            itemtoDrop = MAP_EQ_TABLE_LONGEST[math.random(0, #MAP_EQ_TABLE_LONGEST - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "prisoner" then
            itemtoDrop = MAP_EQ_TABLE_PRISONER[math.random(0, #MAP_EQ_TABLE_PRISONER - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "ratrace" then
            itemtoDrop = MAP_EQ_TABLE_RATRACE[math.random(0, #MAP_EQ_TABLE_RATRACE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "sidewinder" then
            itemtoDrop = MAP_EQ_TABLE_SIDEWINDER[math.random(0, #MAP_EQ_TABLE_SIDEWINDER - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "timberland" then
            itemtoDrop = MAP_EQ_TABLE_TIMBERLANDE[math.random(0, #MAP_EQ_TABLE_TIMBERLANDE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "wizard" then
            itemtoDrop = MAP_EQ_TABLE_WIZARD[math.random(0, #MAP_EQ_TABLE_WIZARD - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        end
    end

    -- Based on Game-Type --
    if BasedOnGameType == true and BasedOnMap == false then
        -- Check if gametype is CTF.
        if game_type == "ctf" then
            itemtoDrop = GAMETYPE_EQ_TABLE_CTF[math.random(0, #GAMETYPE_EQ_TABLE_CTF - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
            -- Check if gametype is SLAYER.
        elseif game_type == "slayer" then
            itemtoDrop = GAMETYPE_EQ_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_TABLE_SLAYER - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        end
    end
end

-- Do Not Touch!
function OnError(Message)
    print(debug.traceback())
end

--[[

    -- Equipment --
"eqip", "powerups\\active camouflage"
"eqip", "powerups\\health pack"
"eqip", "powerups\\over shield"
"eqip", "powerups\\assault rifle ammo\\assault rifle ammo"
"eqip", "powerups\\needler ammo\\needler ammo"
"eqip", "powerups\\pistol ammo\\pistol ammo"
"eqip", "powerups\\rocket launcher ammo\\rocket launcher ammo"
"eqip", "powerups\\shotgun ammo\\shotgun ammo"
"eqip", "powerups\\sniper rifle ammo\\sniper rifle ammo"
"eqip", "powerups\\flamethrower ammo\\flamethrower ammo"

    -- Weapons --
"weap", "weapons\\assault rifle\\assault rifle"
"weap", "weapons\\flamethrower\\flamethrower"
"weap", "weapons\\needler\\mp_needler"
"weap", "weapons\\pistol\\pistol"
"weap", "weapons\\plasma pistol\\plasma pistol"
"weap", "weapons\\plasma rifle\\plasma rifle"
"weap", "weapons\\plasma_cannon\\plasma_cannon"
"weap", "weapons\\rocket launcher\\rocket launcher"
"weap", "weapons\\shotgun\\shotgun"
"weap", "weapons\\sniper rifle\\sniper rifle"

]]