# Starter Prompt for New AI Session

**Copy and paste this into a new chat to get started:**

---

## 🎯 New Session Starter Prompt

```
I'm working on a Baldur's Gate 3 mod project (WoW Warrior class implementation). 

Please read the comprehensive handover document to get full context:
HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md

Key context:
- This is a systematic SOURCE_OF_TRUTH.md review and documentation project
- We just completed repository cleanup (root directory + SOURCE_OF_TRUTH root folder)
- All legacy backups archived to Documentation/00_SourcesOfTruth/Archive/OldVersions/
- SOURCE_OF_TRUTH.md is 76.9% complete (Sections [1]-[12] reviewed, [13]-[15] pending)
- All 18 transformation files (FILES 1-18) are complete
- Mod is 100% functional and ready for testing

CRITICAL PROTOCOLS (from .agent.md in root):
1. ALWAYS read Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md relevant section BEFORE making changes
2. ALWAYS update SOURCE_OF_TRUTH.md AFTER changes (timestamp + change log entry)
3. ALWAYS check TROUBLESHOOTING_LOG.md BEFORE attempting fixes
4. NEVER use Archive/ information without user request
5. File creation: Check Section [12] Folder Structure Inventory first

I'm ready to continue with one of these options:
A) Resume systematic SOURCE_OF_TRUTH review (Section [13] Master Ability Database)
B) Create missing test scripts (FILE_12_Test-SpellLists.ps1, etc.)
C) In-game testing session
D) Continue repository cleanup (Scripts/, Reports/, Tests/ folders)

Which option would you like me to choose, or do you have a different priority?
```

---

## 📋 Alternative Shorter Version

If you want a more concise starter:

```
Working on BG3 mod (WoW Warrior class). Please read HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md for full context.

Key points:
- Systematic SOURCE_OF_TRUTH.md review in progress (76.9% complete)
- Just finished cleanup: root directory + SOURCE_OF_TRUTH root folder
- All FILES 1-18 complete, mod is functional
- CRITICAL: Always read SOURCE_OF_TRUTH.md sections before changes, update after with timestamps

Ready to continue with:
A) Section [13] review (Master Ability Database)
B) Create missing test scripts
C) In-game testing
D) More cleanup

Which option?
```

---

## 🎨 Customized by Task

### If you want to focus on Section [13] review:

```
Working on BG3 mod. Read HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md for context.

I want to continue the systematic SOURCE_OF_TRUTH.md review. We completed Sections [1]-[12] on Oct 25-26. Next is Section [13] Master Ability Database.

Review protocol:
1. Read Section [13] in SOURCE_OF_TRUTH.md
2. Read actual implementation (AbilityDatabase_Warrior_FullyEnriched.csv)
3. Identify inaccuracies/gaps/outdated info
4. Update section with corrections
5. Update timestamp + add change log entry
6. Confirm completion

Please start Section [13] review.
```

### If you want to create test scripts:

```
Working on BG3 mod. Read HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md for context.

I need to create missing validation test scripts. Priority:
1. FILE_12_Test-SpellLists.ps1 (validate 72 SpellList nodes)
2. FILE_13_Test-PassiveLists.ps1 (validate 59 PassiveList nodes)
3. FILE_14_Test-ProgressionDescriptions.ps1 (validate 36 nodes)

Follow the pattern from Test-MetaLsx.ps1 and Test-ClassDescriptions.ps1 (in Transformation_Templates/Tests/).

Start with FILE_12_Test-SpellLists.ps1. Show me the plan first before creating.
```

### If you want in-game testing:

```
Working on BG3 mod. Read HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md for context.

Ready for comprehensive in-game testing session. The mod is packaged and functional (FILES 1-18 complete).

Testing priorities:
1. Character creation system (FILES 16-18): Ability presets, skill selection
2. L1-12 progression: Ability grants, rage generation
3. L13 hero talent selection (currently auto-grants both trees - known issue)
4. Charge resource system in combat

Help me create a testing checklist and guide me through validation.
```

### If you want to continue cleanup:

```
Working on BG3 mod. Read HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md for context.

Just completed root directory and SOURCE_OF_TRUTH folder cleanup. Ready to organize more folders.

Next cleanup targets:
- Scripts/ folder (organize by category)
- Reports/ folder (archive old reports)
- Tests/ folder (organize test data)

Let's start with Scripts/ folder. Do a dry run first showing what you plan to move, then I'll approve.
```

---

## 💡 Pro Tips for New Session

1. **Always mention the handover**: The AI needs to read it to get full context
2. **Specify your priority**: Choose one of the 4 main options (A/B/C/D)
3. **Reference protocols**: Mention SOURCE_OF_TRUTH protocol if doing reviews
4. **Ask for plans first**: "Show me the plan before executing" ensures nothing unexpected
5. **Be specific**: If you want Section [13], say "Section [13]" not "next section"

---

**Remember**: The handover document (HANDOVER_SOURCE_OF_TRUTH_REVIEW_OCT26.md) contains:
- Complete session history
- Current state of all 18 files
- Validation test results
- Known issues
- Recommended next steps
- Critical protocols

The AI should read it at the start of every new session!

---

*This starter prompt guide ensures smooth continuation across chat sessions with full context preservation.*
