-- BG3Wow Script Extender Bootstrap (Client)
-- This file logs mod loading on the client side

Ext.Require("BootstrapShared.lua")

-- Log when client starts
_P("========================================")
_P("[BG3WOW] CLIENT BOOTSTRAP LOADING")
_P("[BG3WOW] Version: 2.0.0 - Equipment Fix Test")
_P("[BG3WOW] Script Extender: " .. Ext.Utils.Version())
_P("========================================")

Ext.Events.SessionLoaded:Subscribe(function()
    _P("[BG3WOW] ✅ Client Session Loaded Successfully")
end)

Ext.Events.GameStateChanged:Subscribe(function(e)
    _P("[BG3WOW] Game State: " .. tostring(e.FromState) .. " → " .. tostring(e.ToState))
end)

-- Log errors
Ext.Events.Tick:Subscribe(function()
    -- Only run once
    Ext.Events.Tick:Unsubscribe()
    _P("[BG3WOW] ✅ Client Tick Running - Mod Active")
end)

_P("[BG3WOW] ===== CLIENT BOOTSTRAP COMPLETE =====")
