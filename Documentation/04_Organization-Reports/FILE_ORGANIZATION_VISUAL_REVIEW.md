# File Organization Plan - Visual Review

## 📂 Folder Structure (New Folders to Create)

```
BG3Mods/
├── Reports/
│   ├── 01_SessionSummaries/           ✅ EXISTS
│   ├── 03_SectionCompletionReports/   🆕 CREATE
│   ├── 04_FeatureReports/             🆕 CREATE
│   └── 05_ValidationReports/          🆕 CREATE
│
└── Documentation/
    ├── 08_TransformationTemplates/
    │   └── SectionDrafts/             🆕 CREATE
    └── 09_Handover/                   🆕 CREATE
```

---

## 📋 File Movement Plan (20 Files)

### ✅ KEEP IN ROOT (4 files - DO NOT MOVE)
```
✅ README.md                          (project overview)
✅ INDEX.md                           (document navigation)
✅ BG3Mods.code-workspace             (VS Code workspace)
✅ settings.json                      (LSLib/Multitool settings)
```

---

### 📁 Category 1: Session Summaries (2 files)
**Destination**: `Reports/01_SessionSummaries/`

```
SESSION_HANDOVER_SECTION_3_COMPLETE.md  →  Reports/01_SessionSummaries/
USER_REVIEW_COMPLETE_OCT20.md           →  Reports/01_SessionSummaries/
```

**Purpose**: Historical session handover documents

---

### 📁 Category 2: Section Drafts (2 files)
**Destination**: `Documentation/08_TransformationTemplates/SectionDrafts/`

```
SECTION_4.2_FURY_WARRIOR_DRAFT.md       →  Documentation/08_TransformationTemplates/SectionDrafts/
SECTION_4.3_PROTECTION_WARRIOR_DRAFT.md →  Documentation/08_TransformationTemplates/SectionDrafts/
```

**Purpose**: Archive copies of section drafts before they were inserted into SOURCE_OF_TRUTH.md

---

### 📁 Category 3: Section Completion Reports (10 files)
**Destination**: `Reports/03_SectionCompletionReports/`

```
SECTION_3.3_L11_L12_EXTENSION_COMPLETE.md   →  Reports/03_SectionCompletionReports/
SECTION_3.3_LABEL_VERIFICATION_REPORT.md    →  Reports/03_SectionCompletionReports/
SECTION_3_COMPLETE_SUMMARY.md               →  Reports/03_SectionCompletionReports/
SECTION_4.1_ALL_IMPROVEMENTS_COMPLETE.md    →  Reports/03_SectionCompletionReports/
SECTION_4.1_ARMS_COMPLETE.md                →  Reports/03_SectionCompletionReports/
SECTION_4.1_IMPROVEMENT_RECOMMENDATIONS.md  →  Reports/03_SectionCompletionReports/
SECTION_4.2_FURY_COMPLETE.md                →  Reports/03_SectionCompletionReports/
SECTION_4_COMPLETE.md                       →  Reports/03_SectionCompletionReports/
SECTION_4_PROGRESS_REPORT.md                →  Reports/03_SectionCompletionReports/
SECTION_4_SUBCLASSES_PLAN.md                →  Reports/03_SectionCompletionReports/
```

**Purpose**: Milestone reports documenting completion of major sections

---

### 📁 Category 4: Feature/Design Reports (4 files)
**Destination**: `Reports/04_FeatureReports/`

```
BUILD_ARCHETYPES_CLARIFICATION.md           →  Reports/04_FeatureReports/
IMPROVEMENT_2_ENHANCED_BIDIRECTIONAL.md     →  Reports/04_FeatureReports/
TOOLTIP_ARCHETYPE_TAGGING_FEASIBILITY.md    →  Reports/04_FeatureReports/
TOOLTIP_INNOVATION_SESSION_MILESTONE.md     →  Reports/04_FeatureReports/
```

**Purpose**: Feature proposals, design decisions, innovation documentation

---

### 📁 Category 5: Validation/Correction Reports (2 files)
**Destination**: `Reports/05_ValidationReports/`

```
EXCEL_RESCAN_CORRECTIONS_APPLIED.md         →  Reports/05_ValidationReports/
WOWWARLOCK_FRAMEWORK_CHECK_OCT20.md         →  Reports/05_ValidationReports/
```

**Purpose**: Data validation, error correction, quality assurance reports

---

### 📁 Category 6: Handover Documents (2 files)
**Destination**: `Documentation/09_Handover/`

```
HANDOVER_FILE_BY_FILE_START.md              →  Documentation/09_Handover/
HANDOVER_NEXT_SESSION_OCT20.md              →  Documentation/09_Handover/
```

**Purpose**: Session handover documents for AI agent continuity

**Note**: 
- `HANDOVER_FILE_BY_FILE_START.md` = OUTDATED (Oct 18, file transformation strategy)
- `HANDOVER_NEXT_SESSION_OCT20.md` = CURRENT (Oct 20, Section [4] complete)

---

## 📊 Summary Table

| Category | Destination | File Count | Purpose |
|----------|-------------|------------|---------|
| **Keep in Root** | `.` (root) | 4 | Essential project files |
| **Session Summaries** | `Reports/01_SessionSummaries/` | 2 | Historical handovers |
| **Section Drafts** | `Documentation/08_TransformationTemplates/SectionDrafts/` | 2 | Pre-insertion drafts |
| **Completion Reports** | `Reports/03_SectionCompletionReports/` | 10 | Milestone documentation |
| **Feature Reports** | `Reports/04_FeatureReports/` | 4 | Design decisions |
| **Validation Reports** | `Reports/05_ValidationReports/` | 2 | Quality assurance |
| **Handover Docs** | `Documentation/09_Handover/` | 2 | AI agent continuity |
| **TOTAL TO MOVE** | | **22** | |

---

## 🔍 Rationale for Organization

### Why Reports/ Folder?
- **Session-based work** (summaries, milestones, validations)
- **Temporal documents** (represents point-in-time state)
- **Reference material** (look back at history)

### Why Documentation/ Folder?
- **Evergreen content** (templates, handovers)
- **Reusable patterns** (section drafts as templates)
- **Future reference** (handover docs for new sessions)

### Why Separate Subfolders?
- **01_SessionSummaries**: Historical session work
- **03_SectionCompletionReports**: Major milestone achievements
- **04_FeatureReports**: Design decisions and innovations
- **05_ValidationReports**: Quality assurance and corrections
- **08_TransformationTemplates/SectionDrafts**: Reusable section patterns
- **09_Handover**: AI agent continuity documents

---

## ⚠️ Important Notes

### Files NOT in This Plan (Already Organized)
These files are already in proper locations:
- `.github/copilot-instructions.md` ✅ (AI instructions)
- `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` ✅ (main doc)
- `Reports/02_Transformation/FILE_BY_FILE_TRANSFORMATION_PLAN.md` ✅ (transformation plan)
- All files in `Tests/`, `Data/`, `Package/`, `LsLib/`, `Scripts/` ✅

### Handover Document Status
- **OLD**: `HANDOVER_FILE_BY_FILE_START.md` (Oct 18, 2025 - file transformation focus)
- **NEW**: `HANDOVER_NEXT_SESSION_OCT20.md` (Oct 20, 2025 - Section [4] complete, ready for Section [5])

### After File Movement
You'll need to:
1. ✅ Update README.md if it references moved files
2. ✅ Update INDEX.md with new paths
3. ✅ Update SOURCE_OF_TRUTH.md Section [12] with folder structure
4. ✅ Update change log in SOURCE_OF_TRUTH.md

---

## 🎯 Final Result

**Root Directory (After Cleanup)**:
```
BG3Mods/
├── README.md                    ✅
├── INDEX.md                     ✅
├── BG3Mods.code-workspace       ✅
├── settings.json                ✅
├── FILE_ORGANIZATION_SUMMARY.md (this file - can be moved to Reports after cleanup)
├── .github/
├── .vscode/
├── Archive/
├── Backups/
├── Data/
├── Documentation/
├── LsLib/
├── Package/
├── Reports/
├── Scripts/
├── Tests/
└── Transformation_Templates/
```

**Clean, organized, professional structure!** 🎉

---

## ✅ Review Checklist

Before proceeding, confirm:

- [ ] Folder destinations make sense (Reports vs Documentation)
- [ ] Category assignments are correct (Session Summaries, Completion Reports, etc.)
- [ ] Essential root files are not being moved (README, INDEX, workspace, settings)
- [ ] Handover documents will be accessible in Documentation/09_Handover/
- [ ] No critical files are being moved to wrong locations

**If everything looks good, proceed with file organization in new chat!**
