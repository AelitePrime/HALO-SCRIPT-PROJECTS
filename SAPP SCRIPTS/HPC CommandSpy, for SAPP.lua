--[[
------------------------------------
Script Name: HPC CommandSpy, for SAPP
    - Implementing API version: 1.11.0.0

Description: Spy on your players commands!
             This script will show commands typed by non-admins (to admins). 
             Admins wont see their own commands (:

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

    Change Log:
        [^] Initial Upload
        [*] Fixed a rather terrible bug.
        
Copyright �2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]--

--[[
    
Set color of console (0-255). Setting to 0 is white over black. !
0 - Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red
5 - Magenta, 6 - Gold, 7 - White. !
Add 8 to make text bold. !
Add 16 x Color to set background color.
    
]]

-- Console only -- 
CommandOutputColor = 4+8 -- Magenta

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnChatMessage")
end

function OnChatMessage(PlayerIndex, Message)
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then
        AdminIndex = tonumber(PlayerIndex)
    end
    local t = tokenizestring(Message)
    count = #t
    local Message = tostring(Message)
    iscommand = nil
    if string.sub(t[1], 1, 1) == "/" or string.sub(t[1], 1, 1) == "\\" then 
        iscommand = true
        output("* Executing Command: \"" .. Message .. "\" from " .. get_var(PlayerIndex, "$name"))
    else 
        iscommand = false
    end
    if (tonumber(get_var(PlayerIndex,"$lvl"))) == -1 then
        RegularPlayer = tonumber(PlayerIndex)
        if player_present(RegularPlayer) ~= nil then
            if iscommand then 
                if RegularPlayer then
                    CommandSpy("SPY:    " .. get_var(PlayerIndex, "$name") .. ":    " .. Message, AdminIndex)
                end
            end
        end
    end
end

function CommandSpy(Message, AdminIndex) 
    for i = 1,16 do
        if i ~= RegularPlayer then
            rprint(i, Message)
        end
    end
end

function output(Message, PlayerIndex)
    if Message then
        if Message == "" then
            return
        end
        cprint(Message, CommandOutputColor)
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end