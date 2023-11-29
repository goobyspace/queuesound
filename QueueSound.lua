-------------------------------
-- Namespaces & Variables
-------------------------------
local _, core = ...
core.QueueSound = {}
local QueueSound = core.QueueSound;

local musicPlay
local ramonesSoundHandle
local battlefieldIDs = {};
-------------------------------
-- QueueSound
-- in QueueSound we 1: Listen for events related to queue windows
-- 2: Check if the conditions are met to play the sound
-- 3: Play the actual sounds
-- To-do: Split checkers into seperate functions for clarity and cleanliness(Arenas don't need to run every single LFR statement vice versa)
-- Create sound for more than one BG type
-------------------------------

-- The following 2 check your arena and LFG q status
function QueueSound:arenaStatusChecker(key)
    local queueStatus, _, _, _, _, battlefieldType = GetBattlefieldStatus(key);
    return queueStatus, battlefieldType
end

function QueueSound:lfgStatusChecker()
    local _, _, _, dungType, _, _, _, dungResp = GetLFGProposal()
    return dungType, dungResp
end

--Plays the music/stops it depending on what boolean value you enter into the function
local function arenaPlayMusic(playSound, soundFile)
    local _
    if playSound == true then
        _, ramonesSoundHandle = PlaySoundFile(soundFile, "Master")
    end
    if playSound == false then
        if ramonesSoundHandle ~= nil then
            StopSound(ramonesSoundHandle)
        end
    end
end

-- queueStatus can return none, queued, confirm or active, none for no current q
-- ratedStatus can return BATTLEGROUND, ARENASKIRMISH, RATEDSHUFFLE or ARENA, nil for no current q
-- dungType can return 1 for normal dungeons, 2 for heroics, 3 for LFR, 4 for scenarios(old) and 5 for flex raids(old), nil for no current q
-- dungResp can return either true if a response(either accept or decline) has been given, false if no response has been given, nil for no current q
local function arenaEventHandler(self, event, ...)
    local arenaToggleState, shuffleToggleState, bgToggleState, skrmToggleState, LFDToggleState, LFRToggleState = core
        .Config.VarStates();
    local arenaSong, shuffleSong, bgSong, skrmSong, LFDSong, LFRSong = core.Config.MuscStates();
    if musicPlay == nil then
        musicPlay = false
    end

    -- PvP Checker
    local maxBattlefieldID = GetMaxBattlefieldID();
    for i = 1, maxBattlefieldID, 1 do
        if battlefieldIDs[i] == nil then
            battlefieldIDs[i] = false;
        end

        local queueStatus, battlefieldType = core.QueueSound:arenaStatusChecker(i);
        if queueStatus == "confirm" then
            if battlefieldType == "ARENA" and arenaToggleState == true then
                arenaPlayMusic(true, arenaSong)
                battlefieldIDs[i] = true;
            end
            if battlefieldType == "RATEDSHUFFLE" and shuffleToggleState == true then
                arenaPlayMusic(true, shuffleSong)
                battlefieldIDs[i] = true;
            end
            if battlefieldType == "BATTLEGROUND" and bgToggleState == true then
                arenaPlayMusic(true, bgSong)
                battlefieldIDs[i] = true;
            end
            if battlefieldType == "BRAWLSOLORBG" and bgToggleState == true then
                arenaPlayMusic(true, bgSong)
                battlefieldIDs[i] = true;
            end
            if battlefieldType == "ARENASKIRMISH" and skrmToggleState == true then
                arenaPlayMusic(true, skrmSong)
                battlefieldIDs[i] = true;
            end
        end
        --need to have some kind of "only stop if its the same i that started the music"
        if queueStatus ~= "confirm" and battlefieldIDs[i] == true then
            arenaPlayMusic(false, nil)
            battlefieldIDs[i] = false;
        end
    end

    --- Dungeon/LFR Checker
    local dungType, dungResp = core.QueueSound:lfgStatusChecker();
    if dungResp == false and dungType > 0 and musicPlay == false then
        if (dungType == 1 or dungType == 2) and LFDToggleState == true then
            arenaPlayMusic(true, LFDSong)
            musicPlay = true
        end
        if dungType >= 3 and LFRToggleState == true then
            arenaPlayMusic(true, LFRSong)
            musicPlay = true
        end
    end
    if dungResp == true then
        arenaPlayMusic(false, nil)
        musicPlay = false
    end
end

function QueueSound:arenaSoundInit()
    local arenaSoundFrame = CreateFrame("Frame")
    arenaSoundFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
    arenaSoundFrame:SetScript("OnEvent", arenaEventHandler)
    local lfdSoundFrame = CreateFrame("Frame")
    lfdSoundFrame:RegisterEvent("LFG_PROPOSAL_UPDATE")
    lfdSoundFrame:SetScript("OnEvent", arenaEventHandler)
end
