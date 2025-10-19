-- BG3Wow Script Extender Bootstrap (Server)
-- This file logs mod loading and helps diagnose issues

Ext.Require("BootstrapShared.lua")

-- Log when server starts
_P("========================================")
_P("[BG3WOW] SERVER BOOTSTRAP LOADING")
_P("[BG3WOW] Version: 2.0.0 - Equipment Fix Test")
_P("[BG3WOW] Script Extender: " .. Ext.Utils.Version())
_P("========================================")

Ext.Events.SessionLoaded:Subscribe(function()
    _P("[BG3WOW] ✅ Server Session Loaded Successfully")
    
    -- Try to check if our class data loaded
    local success, err = pcall(function()
        _P("[BG3WOW] Checking for Warrior class definitions...")
        -- This will help identify if class data is being read
    end)
    
    if not success then
        _P("[BG3WOW] ❌ ERROR in SessionLoaded: " .. tostring(err))
    end
end)

Ext.Events.ResetCompleted:Subscribe(function()
    _P("[BG3WOW] ✅ Reset Completed - Game Ready")
end)

-- Register mod info
Ext.Osiris.RegisterListener("GameStarted", 2, "after", function(_, _)
    _P("[BG3WOW] ✅ GameStarted Event - Server Initialized")
end)

-- Log when a level loads
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    _P("[BG3WOW] Level Loaded: " .. tostring(levelName))
    _P("[BG3WOW] Editor Mode: " .. tostring(isEditorMode))
end)

-- Log when a character is created
Ext.Osiris.RegisterListener("CharacterCreationFinished", 1, "after", function(character)
    _P("[BG3WOW] ✅ Character Created: " .. tostring(character))
end)

_P("[BG3WOW] ===== SERVER BOOTSTRAP COMPLETE =====")
