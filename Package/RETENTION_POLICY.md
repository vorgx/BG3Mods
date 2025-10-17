# Package Retention Policy

## Overview

This document defines the retention and archival strategy for BG3Wow mod package files (.pak). The goal is to maintain a clean working directory while preserving historical builds for reference and rollback.

## Current Structure

```
Package/
├── BG3Wow_Latest.pak              # Symbolic latest version (always current)
├── CHANGELOG.md                   # Version history
├── RETENTION_POLICY.md            # This file
├── ARCHIVE_PACKAGES.ps1           # Archival automation script
├── INSTALL_GUIDE.md               # Installation instructions
├── README.md                      # Package folder documentation
└── Archive/                       # Historical versions
    ├── v1.0.0.0/                 # Initial release
    ├── v1.0.0.1/                 # Bug fixes
    ├── v1.0.0.2/                 # Script Extender integration
    └── v1.0.0.3/                 # Localization fixes
```

## Retention Rules

### Active Versions (Package/ Root)
**Keep in root directory:**
- `BG3Wow_Latest.pak` - Always the most recent build (manual copy/rename)
- Most recent 2 patch versions (e.g., v1.0.0.3_LOCFIX.pak)

**Purpose**: Quick access for testing and distribution

### Archived Versions (Package/Archive/)
**Keep in Archive/ subfolders:**
- **Last 3 major/minor versions** (e.g., v1.0.0.x, v1.0.1.x, v1.1.0.x)
- **Milestone versions** marked in CHANGELOG.md (e.g., first stable, Patch 8 compatibility)
- **Known-good builds** referenced in validation reports

**Purge from Archive/:**
- Patch versions older than 3 releases (unless milestone)
- Duplicate/test builds with identical version numbers
- Builds that failed validation or caused crashes

### Special Cases
- **First release (v1.0.0.0)**: Always keep for historical reference
- **SE integration (v1.0.0.2)**: Keep as Script Extender baseline
- **Localization baseline (v1.0.0.3_LOCFIX)**: Keep as current stable

## Archival Workflow

### Manual Method
1. Identify versions older than last 2 patches
2. Move .pak file to corresponding Archive/vX.X.X.X/ folder
3. Update CHANGELOG.md with archive date
4. Verify BG3Wow_Latest.pak points to current version

### Automated Method (Recommended)
```powershell
# Dry-run to preview changes
.\ARCHIVE_PACKAGES.ps1 -WhatIf

# Execute archival
.\ARCHIVE_PACKAGES.ps1

# Verify structure
Get-ChildItem -Recurse -Filter "*.pak"
```

## Version Naming Convention

**Format**: `BG3Wow_vX.Y.Z.P[_SUFFIX].pak`

- **X**: Major version (breaking changes, complete rework)
- **Y**: Minor version (new features, specs, abilities)
- **Z**: Patch version (bug fixes, balance tweaks)
- **P**: Build number (incremental within patch)
- **SUFFIX** (optional): `_FIXED`, `_SE`, `_LOCFIX`, etc.

**Examples**:
- `BG3Wow_v1.0.0.0.pak` - Initial release
- `BG3Wow_v1.0.0.1_FIXED.pak` - Patch 1 with hotfixes
- `BG3Wow_v1.0.0.2_SE.pak` - Script Extender integration
- `BG3Wow_v1.0.0.3_LOCFIX.pak` - Localization fixes

## Pre-Archival Checklist

Before archiving a version, verify:
- [ ] Version documented in CHANGELOG.md
- [ ] No validation reports referencing this build as "known-good"
- [ ] Not marked as milestone in project documentation
- [ ] Newer version successfully tested in-game
- [ ] Version older than last 3 releases

## Restoration Workflow

To restore an archived version for testing:
1. Navigate to Archive/vX.X.X.X/
2. Copy .pak file to Package/ root (do NOT move)
3. Rename to include `_ROLLBACK` suffix
4. Install to game Mods/ folder
5. Document reason in CHANGELOG.md

## Cleanup Frequency

**Recommended schedule**:
- After every 3 patch releases (archive older versions)
- Before major/minor version bump (archive all old patches)
- Monthly review of Archive/ for duplicates/test builds
- After successful in-game validation of new version

## Storage Estimates

- Average .pak size: 10-50 KB (BG3Wow is data-only mod)
- 10 archived versions: ~500 KB total
- Retention policy impact: Minimal disk usage

## Related Documentation

- **CHANGELOG.md**: Version history with dates and changes
- **INSTALL_GUIDE.md**: User-facing installation instructions
- **Tests/01_ValidationReports/VALIDATION_STATUS_FINAL.md**: Current mod readiness
- **.github/copilot-instructions.md**: Pre-packaging validation checklist

## Policy Updates

**Last Updated**: October 17, 2025  
**Policy Version**: 1.0  
**Next Review**: After v1.1.0.0 release or 6 months (April 2026)
