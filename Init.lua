-------------------------------
-- Namespaces
-------------------------------
local _, core = ...
local songPath = "Interface\\AddOns\\QueueSound\\"
-------------------------------
-- Init
-- in the initializer we 1: Create our /commands and handle the inputs the user puts behind them
-- 2: Set our global bools to true if they have not yet been set
-- ^ might not be required anymore now that we use the proper blizzard settings menu?
-- 3: Initialize our actual code from Queuesound
-------------------------------
core.commands = {
    ["config"] = function() core.Config:Toggle() end,
    ["vars"] = function()
        print(DevTools_Dump(QsVariableArray));
    end,
    ["help"] = function()
        print(" ")
        print("Queue Sound Help")
        print("|cff00cc66/qs config|r - shows config menu");
        print("|cff00cc66/qs help|r - shows help info");
        print(" ")
    end
}
local function slashCommandHandler(str)
    if (#str == 0) then
        core.commands.help()
    end
    -- turn arguments after / command into table and then check if they match a function and what the other arguments are, if they dont match a function request help
    local args = {};
    for _, arg in ipairs({ string.split(' ', str) }) do
        if (#arg > 0) then
            table.insert(args, arg);
        end
    end

    local path = core.commands; -- required for updating found table.

    for id, arg in ipairs(args) do
        if (#arg > 0) then -- if string length is greater than 0.
            arg = arg:lower();
            if (path[arg]) then
                if (type(path[arg]) == "function") then
                    -- all remaining args passed to our function!
                    path[arg](select(id + 1, unpack(args)));
                    return;
                elseif (type(path[arg]) == "table") then
                    path = path[arg]; -- another sub-table found!
                end
            else
                -- does not exist!
                core.commands.help();
                return;
            end
        end
    end
end

local function VarChecker()
    if QsVariableArray == nil then
        QsVariableArray = {};
    end
    --if theres no arena state: add the arena states
    --the pvp names should match the battlegroundtype names
    --remember to add new settings to config.lua too
    if QsVariableArray["ARENA"] == nil then
        QsVariableArray["ARENA"] = true;
        QsVariableArray["RATEDSHUFFLE"] = true;
        QsVariableArray["BATTLEGROUND"] = true;
        QsVariableArray["RATEDSOLORBG"] = true;
        QsVariableArray["ARENASKIRMISH"] = true;
        QsVariableArray["LFD"] = true;
        QsVariableArray["LFR"] = true;
    end

    QsVariableArray["song"] = songPath .. "sound" .. ".mp3";
end

local function QSDebugMode(debugMode)
    if debugMode == true then
        SLASH_RELOADUI1 = "/rl" -- For quicker reloading whilst debugg
        SlashCmdList.RELOADUI = ReloadUI

        SLASH_FRAMESTK1 = "/fs" -- For quicker access to frame stack
        SlashCmdList.FRAMESTK = function()
            FrameStackTooltip_Toggle()
        end

        for i = 1, NUM_CHAT_WINDOWS do
            _G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false)
        end
    end
end

function core:InitEventHandler(event, name)
    if name ~= "QueueSound" then return end
    core.QueueSound.arenaSoundInit()
    VarChecker()
    -------------------------
    --- Slash Commands ---
    -------------------------
    SLASH_QSoundShort1 = "/QS"
    SlashCmdList.QSoundShort = slashCommandHandler
    SLASH_QSound1 = "/QSound"
    SlashCmdList.QSound = slashCommandHandler
    core.Config:CreateMenu()
    QSDebugMode(false)
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", core.InitEventHandler)
