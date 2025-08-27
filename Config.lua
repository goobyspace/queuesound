-------------------------------
-- Namespaces & Variables
-------------------------------
local _, core = ...
core.Config = {}
local Config = core.Config
local arenaSoundconfig
-------------------------------

function Config:CreateMenu()
    -- there's practically 0 documentation on this, but you can find some stuff by searching through the wow UI source
    -- https://github.com/Gethe/wow-ui-source
    local category, layout = Settings.RegisterVerticalLayoutCategory("Queue Sound")

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("PvP"));
    do
        do
            local name = "Shuffle"
            local variable = "playShuffle"
            local variableKey = "RATEDSHUFFLE"
            local defaultValue = true

            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey,
                QsVariableArray,
                type(defaultValue),
                name, defaultValue)

            local tooltip =
            "Play a sound on solo shuffle queue pop."
            Settings.CreateCheckbox(category, setting, tooltip)
        end
        do
            local name = "Blitz"
            local variable = "playBlitz"
            local variableKey = "RATEDSOLORBG"
            local defaultValue = true

            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey,
                QsVariableArray,
                type(defaultValue),
                name, defaultValue)

            local tooltip =
            "Play a sound on BG Blitz queue pop."
            Settings.CreateCheckbox(category, setting, tooltip)
        end
        do
            local name = "Arena"
            local variable = "playArena"
            local variableKey = "ARENA"
            local defaultValue = true

            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey,
                QsVariableArray,
                type(defaultValue),
                name, defaultValue)

            local tooltip =
            "Play a sound on arena queue pop."
            Settings.CreateCheckbox(category, setting, tooltip)
        end
        do
            local name = "Battlegrounds"
            local variable = "playBattlegrounds"
            local variableKey = "BATTLEGROUND"
            local defaultValue = true

            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey,
                QsVariableArray,
                type(defaultValue),
                name, defaultValue)

            local tooltip =
            "Play sound on battleground queue pop."
            Settings.CreateCheckbox(category, setting, tooltip)
        end
        do
            local name = "Skirmish"
            local variable = "playSkirmish"
            local variableKey = "ARENASKIRMISH"
            local defaultValue = true

            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey,
                QsVariableArray,
                type(defaultValue),
                name, defaultValue)

            local tooltip =
            "Play sound on battleground queue pop."
            Settings.CreateCheckbox(category, setting, tooltip)
        end
    end

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("PvE"));
    do
        do
            local name = "Looking for Dungeons"
            local variable = "playDungeons"
            local variableKey = "LFD"
            local defaultValue = true

            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey,
                QsVariableArray,
                type(defaultValue),
                name, defaultValue)

            local tooltip =
            "Play a sound on dungeon queue pop."
            Settings.CreateCheckbox(category, setting, tooltip)
        end
        do
            local name = "Looking for Raid"
            local variable = "playRaid"
            local variableKey = "LFR"
            local defaultValue = true

            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey,
                QsVariableArray,
                type(defaultValue),
                name, defaultValue)

            local tooltip =
            "Play a sound on raid queue pop."
            Settings.CreateCheckbox(category, setting, tooltip)
        end
    end

    Settings.RegisterAddOnCategory(category)

    function core.Config:Toggle()
        Settings.OpenToCategory(category.ID)
    end
end
