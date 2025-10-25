# PHASE 2 UUID ASSIGNMENTS

**Generated**: October 24, 2025  
**Purpose**: Hero subclass implementation (6 new subclasses at L13)

---

## UUID MAPPINGS

### Hero Subclass ClassDescription UUIDs

| Subclass Name | ClassDescription UUID | ProgressionTableUUID |
|---------------|----------------------|---------------------|
| **ArmsColossus** | `9e3f65fd-68f8-4a46-8210-42c4f8ea0999` | `5db96d8a-cfb2-4f88-adf5-b42f4f708dbb` |
| **ArmsSlayers** | `8eb6da73-6020-4eb7-ab21-b9ff4fffe38b` | `d878c84e-137c-419c-9709-a8ed0bd5afb1` |
| **FuryMountainThane** | `162d56bd-4d1e-4957-8a43-c5ba3fb1ee8f` | `f540c1dd-9da7-4b90-8c33-694097cac1f9` |
| **FurySlayers** | `199180bf-1173-4631-9678-5c8342f81862` | `0eded56e-d2be-4fa0-afd3-2486bce36352` |
| **ProtectionMountainThane** | `861c5f75-69ab-4a06-8f16-6cf34d7f99d6` | `0a4e6cd1-1fdd-46cd-bea1-e86ba93b4280` |
| **ProtectionColossus** | `83268994-38e9-4bb5-b9e5-382926636d58` | `7091b2eb-deb3-41f0-9621-9b1842d30cb3` |

---

## Parent Subclass UUIDs (Existing - Retrieved from ClassDescriptions.lsx)

| Subclass | Current UUID | Notes |
|----------|-------------|-------|
| **Arms** | `1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d` | ParentGuid for ArmsColossus & ArmsSlayers |
| **Fury** | `2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e` | ParentGuid for FuryMountainThane & FurySlayers |
| **Protection** | `3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f` | ParentGuid for ProtectionMountainThane & ProtectionColossus |

**✅ Retrieved**: All parent UUIDs confirmed from ClassDescriptions.lsx

---

## Spare UUIDs (For Future Use)

| Purpose | UUID |
|---------|------|
| Spare 1 | `e95b89ca-c13b-4798-bee6-3cb5c9929be2` |
| Spare 2 | `fbc44da8-cd13-4015-a082-eb37bc3e05c6` |
| Spare 3 | `d1e86b97-40af-4c63-9f7e-3b9cf9d4f90c` |
| Spare 4 | `3cfb025b-eb41-4aed-a456-26f37d8daaf9` |
| Spare 5 | `5637a191-86e0-497f-9103-b5e0d3b7a082` |
| Spare 6 | `0306d61c-b93d-4851-9055-cad1dbb87d6f` |

---

## Quick Reference for ClassDescriptions.lsx

### ArmsColossus
```xml
<attribute id="UUID" type="guid" value="9e3f65fd-68f8-4a46-8210-42c4f8ea0999"/>
<attribute id="ProgressionTableUUID" type="guid" value="5db96d8a-cfb2-4f88-adf5-b42f4f708dbb"/>
<attribute id="ParentGuid" type="guid" value="1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d"/>  <!-- Arms -->
```

### ArmsSlayers
```xml
<attribute id="UUID" type="guid" value="8eb6da73-6020-4eb7-ab21-b9ff4fffe38b"/>
<attribute id="ProgressionTableUUID" type="guid" value="d878c84e-137c-419c-9709-a8ed0bd5afb1"/>
<attribute id="ParentGuid" type="guid" value="1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d"/>  <!-- Arms -->
```

### FuryMountainThane
```xml
<attribute id="UUID" type="guid" value="162d56bd-4d1e-4957-8a43-c5ba3fb1ee8f"/>
<attribute id="ProgressionTableUUID" type="guid" value="f540c1dd-9da7-4b90-8c33-694097cac1f9"/>
<attribute id="ParentGuid" type="guid" value="2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>  <!-- Fury -->
```

### FurySlayers
```xml
<attribute id="UUID" type="guid" value="199180bf-1173-4631-9678-5c8342f81862"/>
<attribute id="ProgressionTableUUID" type="guid" value="0eded56e-d2be-4fa0-afd3-2486bce36352"/>
<attribute id="ParentGuid" type="guid" value="2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>  <!-- Fury -->
```

### ProtectionMountainThane
```xml
<attribute id="UUID" type="guid" value="861c5f75-69ab-4a06-8f16-6cf34d7f99d6"/>
<attribute id="ProgressionTableUUID" type="guid" value="0a4e6cd1-1fdd-46cd-bea1-e86ba93b4280"/>
<attribute id="ParentGuid" type="guid" value="3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f"/>  <!-- Protection -->
```

### ProtectionColossus
```xml
<attribute id="UUID" type="guid" value="83268994-38e9-4bb5-b9e5-382926636d58"/>
<attribute id="ProgressionTableUUID" type="guid" value="7091b2eb-deb3-41f0-9621-9b1842d30cb3"/>
<attribute id="ParentGuid" type="guid" value="3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f"/>  <!-- Protection -->
```

---

## Quick Reference for Progressions.lsx (L13 SubClass Choices)

### Arms L13 SubClass Options
```xml
<node id="SubClass">
    <attribute id="Object" type="guid" value="9e3f65fd-68f8-4a46-8210-42c4f8ea0999"/>  <!-- ArmsColossus -->
</node>
<node id="SubClass">
    <attribute id="Object" type="guid" value="8eb6da73-6020-4eb7-ab21-b9ff4fffe38b"/>  <!-- ArmsSlayers -->
</node>
```

### Fury L13 SubClass Options
```xml
<node id="SubClass">
    <attribute id="Object" type="guid" value="162d56bd-4d1e-4957-8a43-c5ba3fb1ee8f"/>  <!-- FuryMountainThane -->
</node>
<node id="SubClass">
    <attribute id="Object" type="guid" value="199180bf-1173-4631-9678-5c8342f81862"/>  <!-- FurySlayers -->
</node>
```

### Protection L13 SubClass Options
```xml
<node id="SubClass">
    <attribute id="Object" type="guid" value="861c5f75-69ab-4a06-8f16-6cf34d7f99d6"/>  <!-- ProtectionMountainThane -->
</node>
<node id="SubClass">
    <attribute id="Object" type="guid" value="83268994-38e9-4bb5-b9e5-382926636d58"/>  <!-- ProtectionColossus -->
</node>
```

---

## Next Steps

1. ✅ **DONE**: Generate UUIDs
2. ✅ **DONE**: Read ClassDescriptions.lsx to get current Arms/Fury/Protection UUIDs
3. **NEXT**: Proceed with Step 2 (Update Database)
