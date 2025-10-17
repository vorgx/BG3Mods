-- BG3Wow Script Extender Bootstrap (Shared)
-- This file runs on both client and server

_P("[BG3WOW] ===== SHARED BOOTSTRAP LOADED =====")
_P("[BG3WOW] Mod UUID: 78fe4967-4e62-5491-d981-dd781acca4d7")
_P("[BG3WOW] Mod Name: BG3Wow - WoW Warrior Class")

-- Helper function to safely print mod info
function BG3Wow_PrintModInfo()
    _P("[BG3WOW] ========================================")
    _P("[BG3WOW] BG3Wow Warrior Class Mod")
    _P("[BG3WOW] Version: 1.0.0.1")
    _P("[BG3WOW] Features:")
    _P("[BG3WOW]   - Warrior Base Class")
    _P("[BG3WOW]   - Arms Subclass")
    _P("[BG3WOW]   - Fury Subclass (WIP)")
    _P("[BG3WOW]   - Protection Subclass (WIP)")
    _P("[BG3WOW]   - Rage Resource System")
    _P("[BG3WOW]   - 19+ Baseline Abilities")
    _P("[BG3WOW]   - 10+ Arms Abilities")
    _P("[BG3WOW] ========================================")
end

-- Print mod info immediately
BG3Wow_PrintModInfo()

_P("[BG3WOW] ===== SHARED BOOTSTRAP COMPLETE =====")
