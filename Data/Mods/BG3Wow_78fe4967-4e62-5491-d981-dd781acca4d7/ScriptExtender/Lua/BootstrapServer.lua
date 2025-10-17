-- BG3Wow Script Extender Bootstrap (Server)
-- This file logs mod loading and helps diagnose issues

Ext.Require("BootstrapShared.lua")

-- Log when server starts
_P("[BG3WOW] ===== SERVER BOOTSTRAP LOADED =====")
_P("[BG3WOW] Script Extender Version: " .. Ext.Utils.Version())
_P("[BG3WOW] Mod is loading successfully!")

-- Register mod info
Ext.Osiris.RegisterListener("GameStarted", 2, "after", function(_, _)
    _P("[BG3WOW] GameStarted event fired - Server side initialized!")
end)

-- Log when a level loads
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    _P("[BG3WOW] Level loaded: " .. levelName)
    _P("[BG3WOW] Editor mode: " .. tostring(isEditorMode))
end)

-- Log when a character is created
Ext.Osiris.RegisterListener("CharacterCreationFinished", 1, "after", function(character)
    _P("[BG3WOW] Character created: " .. character)
    
    -- Check if it's a Warrior
    local entity = Ext.Entity.Get(character)
    if entity and entity.ServerCharacter then
        _P("[BG3WOW] Character entity found, checking class...")
    end
end)

_P("[BG3WOW] ===== SERVER BOOTSTRAP COMPLETE =====")
