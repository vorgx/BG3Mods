This video provides a detailed guide on how to create a custom class mod for Baldur's Gate 3, starting from no mod to a version ready for upload to Nexus Mods. The speaker emphasizes that this is an entry-level guide and the initial class will be minimalistic, with further customization options available by exploring the various folders.

Here's a detailed summary of the steps involved:

1.  **Download Class Template**:
    *   Navigate to the Nexus Mods link provided in the video description.
    *   Manually download the "Class Template" file by Gycicada.
    *   Extract the downloaded `.rar` file using WinRAR.

2.  **Download Modder's Multitool**:
    *   Go to the GitHub link for the Baldur's Gate 3 Modder's Multitool, also found in the video description.
    *   Download the latest version of the tool.
    *   Extract the downloaded file and run the executable. The speaker assures that despite any Windows Defender warnings, the file is safe as he scanned it with Bitdefender.

3.  **Edit Metadata**:
    *   Go into the "Class Template" folder, then `Mods`.
    *   Rename the `Example` folder to your desired mod name (e.g., `Flowerborn`), noting that it is case-sensitive.
    *   Open the `Meta.lsx` file within your renamed mod folder using a text editor like Notepad++.
    *   Change the following five fields:
        *   **Author**: Your Nexus Mods handle.
        *   **Description**: A brief description of your mod for the Mod Manager. The speaker uses a pun: "Stem the Mind Flayer with this new class."
        *   **Folder**: Your case-sensitive mod name (e.g., `Flowerborn`).
        *   **Name**: The name of your mod that will appear in the Mod Manager (e.g., `Flowerborn Class`).
        *   **UUID**: Generate a unique UUID using the Modder's Multitool (untick "Handle" box, click "Generate," then copy and paste).

4.  **Edit Class Description**:
    *   Navigate to `ModName/Public/ModName/ClassDescriptions`.
    *   Open the `ClassDescriptions.lsx` file.
    *   Edit the following fields:
        *   **CanLearnSpells**: Set to `False` (for the "Flowerborn" class, implying flowers can't read spells).
        *   **ClassEquipment**: Copy this line from the subclass section (do not change the value yet, as it will cause a crash if clicked in-game).
        *   **Description** and **DisplayName**: Generate unique UUIDs for these fields using the Modder's Multitool (tick "Handle" box for these).
        *   **MustPrepareSpells**: Set to `False` (flowers need no preparation to be fabulous).
        *   **Name**: Your in-game class name (e.g., `Flowerborn`).
        *   **PrimaryAbility**: Change to the desired ability (e.g., `6` for Charisma, as flowers are persuasive).
        *   **ProgressionTableUUID**: Generate a new unique UUID (untick "Handle" box). Hold on to this code for the next step.
        *   **SoundClassType**: Set to the class you want yours to sound like (e.g., `Druid` as they are closest to flowers).
        *   **SpellCastingAbility**: Set to the attribute chosen for spells (e.g., `6` for Charisma).
        *   **UUID**: Generate another new unique UUID (untick "Handle" box).
        *   **Tags**: Use the codes from the forum link provided in the video description for custom dialogue tags (e.g., Bard and Druid options).
    *   Delete the entire `SubClass` information section to simplify the mod.

5.  **Edit Progression File**:
    *   Go to `ModName/Public/ModName/Progressions`.
    *   Open `Progressions.lsx`.
    *   Edit the following fields:
        *   **Boosts**: Delete the `ActionResource` entry and change `ProficiencyBonus` as desired (e.g., keep others and opt for Charisma proficiency).
        *   **Name**: Change to your mod name (e.g., `Flowerborn`).
        *   **PassivesAdded** and **PassivesRemoved**: Delete these lines for now.
        *   **TableUUID**: Change this to the `ProgressionTableUUID` you obtained from the `ClassDescriptions.lsx` file.
        *   **UUID**: Generate a new unique UUID using the Multitool (untick "Handle" box).
    *   Delete the `MultiClass` and `SubClass` entries.

6.  **Edit Localization File**:
    *   Return to the mod's main folder (`ModName`) and go to `Localization/English`.
    *   Delete the file ending with `.loca`.
    *   Rename the XML file to `ModName.xml` (e.g., `Flowerborn.xml`).
    *   Open the XML file.
    *   Delete all text above the XML line, keeping the syntax structure at the bottom.
    *   Replace the first string with the `DisplayName` handle from `ClassDescriptions.lsx`.
    *   Place your desired class name (e.g., "Flowerborn") as shown.
    *   On the second line, place the `Description` handle from `ClassDescriptions.lsx`.
    *   Place your class description as shown, creating your class's backstory.

7.  **Make LOCA File**:
    *   Download and extract `LSlib` from the GitHub link in the video description.
    *   Launch `LSlib`.
    *   Change the game to `BG3` in the dropdown menu.
    *   Go to the "Localization" tab.
    *   Select your XML file for the "Input Path".
    *   Paste the input path into the "Output Path" and change the `.xml` extension to `.loca`.
    *   Click "Convert".

8.  **Make PAK Mod and Test**:
    *   Open the Modder's Multitool.
    *   Drag your main `ModName` folder (e.g., `Flowerborn`) into the blue box labeled "Drop mod workspace folder or a mod pak here". This will create a `.zip` file ready for upload.
    *   To test the mod, follow the guide in the video description on how to install mods using the Baldur's Gate 3 Mod Manager.
    *   Launch the game, start a new game, and select your custom class in the character creation window.

The video also briefly discusses additional customization options in the `ActionResourceDefinitions`, `Assets`, `CharacterCreationPresets`, `Content`, `GUI`, `Lists`, and `Stats` folders, explaining their purposes for unique resources, icon textures, ability point distributions, UI edits, and character traits, respectively.