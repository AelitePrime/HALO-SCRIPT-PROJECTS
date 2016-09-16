--[[    
------------------------------------
Script Name: HPC Chat Logging, for SAPP
    - Implementing API version: 1.10.0.0
    
Description: This script will log player chat to /logs/Server Chat.txt

* Notes at the bottom of the script.
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"

file_name = "writelog.lua"
WriteToFile = true
local fileDirectory = "logs\\Server Chat.txt"

function OnScriptUnload( )
    
end

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
end

function OnPlayerChat(PlayerIndex, Message)
    
--      Format: [timestamp]     PlayerName [INDEX ID]: <message>
--      Example Output: [15:01:05 - 16/09/2016]     Chalwk: [1]: Seems to be working fine.
    
    local name = get_var(PlayerIndex, "$name")
    local id = get_var(PlayerIndex, "$n")
    local GetChatFormat = string.format("["..get_var(PlayerIndex, "$n").."]: " ..(tostring(Message)))
    
	WriteLog(fileDirectory, name.. " " ..GetChatFormat)
end

function WriteLog(fileDirectory, value)
	local file = io.open(fileDirectory, "a")
    if file then
    	if WriteToFile == true then
            local timestamp = os.date("[%H:%M:%S - %d/%m/%Y]")
            local chatValue = string.format("%s\t%s\n", timestamp, tostring(value))
            file:write(chatValue) -- Write the value of timestamp & GetChatFormat to "/logs/Server Chat.txt"
            file:close() -- Close the file.
        end
    else
--  If the file path "/logs/Server Chat.txt" does not exist, we call CreateDirectory() to produce it.
        cprint("[SCRIPT] " ..file_name.. " - [Function] on WriteLog() - File not Found: " ..fileDirectory)
        cprint("[SCRIPT] " ..file_name.. " - Creating file(s)...")
        CreateDirectory()
	end
end

--  I may update this function in the future to detect if either Logs Folder or Server Chat.txt exists independently.
function CreateDirectory()
    local file = io.open(fileDirectory, "a")
    if file == nil then
        os.execute("mkdir logs") -- Create Logs folder.
        createFile = io.open( "logs\\Server Chat.txt", "w+" ) -- Create Server Chat.txt
        local openInitiate = string.format("File(s) Created!\n")
        createFile:write( openInitiate )
        cprint("[SCRIPT] " ..file_name.. " - successfully created files.")
        createFile:close()
    else
    return false -- File already exists!
    end
end

function OnError(Message)
    print(debug.traceback())
end

--[[
SAPP will log player chat to the sapp.log file, however, it's difficult wade through all the other event logs it handles. 
Personally, I find it convenient to have a 'dedicated' chat.txt file. Which is where this script comes into play.
]]