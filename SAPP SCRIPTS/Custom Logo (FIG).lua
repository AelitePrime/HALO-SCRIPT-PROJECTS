--[[    
------------------------------------
Script Name: Custom Logo, FIG

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 
api_version = "1.11.0.0"

function OnScriptLoad()
    logo = timer(50, "consoleLogo")
    if halo_type == "PC" then ce = 0x0 else ce = 0x40 end
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
	if get_var(0, "$gt") ~= "n/a" then end		
end

function OnScriptUnload()
    
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1,length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

function consoleLogo()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    local timestamp = os.date("%A, %d %B %Y - %X")
    cprint("===================================================================================================", 2+8)
    cprint(timestamp, 6)
    cprint("")
    cprint("                                  '||''''| '||'  ..|'''.|", 4+8)
    cprint("                                   ||  .    ||  .|'     '", 4+8)
    cprint("                                   ||''|    ||  ||    ....", 4+8)
    cprint("                                   ||       ||  '|.    ||", 4+8)
    cprint("                                  .||.     .||.  ''|...'|", 4+8)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("                                   Freedom Internation Gamers")
    cprint("                                    " .. servername, 2+8)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("")
    cprint("===================================================================================================", 2+8)
end
