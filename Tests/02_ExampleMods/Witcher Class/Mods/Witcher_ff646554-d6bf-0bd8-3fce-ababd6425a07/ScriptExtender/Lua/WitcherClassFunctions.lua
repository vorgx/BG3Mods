-- 调试输出函数（如果没有定义 _P 的话）
function _P(msg)
  print(msg)
end

local function TryGetResource(entityGuid, resourceGuid)
  local entity = Ext.Entity.Get(entityGuid)
  if entity then
      local resource = entity.ActionResources.Resources[resourceGuid]
      if resource then
          return resource["1"].Amount
      end
  end
  return 0
end


function GetVitality(guid)

  local success, base = pcall(TryGetResource, guid, "0ea5e366-0f9a-413e-8085-28a5f4269a94")  
  return success and base or 0  
end


function IsWitcher(entity)
  local player = Ext.Entity.Get(entity)
  

  if player.Classes ~= nil then
      for i = 1, 12, 1 do
          if player.Classes.Classes[i] ~= nil then
              if player.Classes.Classes[i].ClassUUID ~= nil then
                  if player.Classes.Classes[i].ClassUUID == "2ae1476b-f3f8-4aa1-8923-39b91c1796ce" then
                      return true
                  end
              end
          end
      end
  end


  return false
end

function IsViperWitcher(entity)
    local player = Ext.Entity.Get(entity)

    if player.Classes ~= nil then
        for i = 1, 12, 1 do
            if player.Classes.Classes[i] ~= nil then
                local classData = player.Classes.Classes[i]

                -- 检查是否是猎魔人职业
                if classData.ClassUUID ~= nil and classData.ClassUUID == "2ae1476b-f3f8-4aa1-8923-39b91c1796ce" then
                    
                    -- 检查子职业（蛇派猎魔人 UUID）
                    if classData.SubClassUUID ~= nil and classData.SubClassUUID == "d9b77432-6abb-422a-88fd-25d29d18fda7" then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function IsBearWitcher(entity)
    local player = Ext.Entity.Get(entity)

    if player.Classes ~= nil then
        for i = 1, 12, 1 do
            if player.Classes.Classes[i] ~= nil then
                local classData = player.Classes.Classes[i]

                -- 检查是否是猎魔人职业
                if classData.ClassUUID ~= nil and classData.ClassUUID == "2ae1476b-f3f8-4aa1-8923-39b91c1796ce" then
                    
                    -- 检查子职业（熊派猎魔人 UUID）
                    if classData.SubClassUUID ~= nil and classData.SubClassUUID == "b73cb84d-42cf-42b6-a1bf-79400669affd" then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function IsWolfWitcher(entity)
    local player = Ext.Entity.Get(entity)

    if player.Classes ~= nil then
        for i = 1, 12, 1 do
            if player.Classes.Classes[i] ~= nil then
                local classData = player.Classes.Classes[i]

                -- 检查是否是猎魔人职业
                if classData.ClassUUID ~= nil and classData.ClassUUID == "2ae1476b-f3f8-4aa1-8923-39b91c1796ce" then
                    
                    -- 检查子职业（狼派猎魔人 UUID）
                    if classData.SubClassUUID ~= nil and classData.SubClassUUID == "a64019e1-3fd0-4af6-9abc-6515a4a06c5a" then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function IsCatWitcher(entity)
    local player = Ext.Entity.Get(entity)

    if player.Classes ~= nil then
        for i = 1, 12, 1 do
            if player.Classes.Classes[i] ~= nil then
                local classData = player.Classes.Classes[i]

                -- 检查是否是猎魔人职业
                if classData.ClassUUID ~= nil and classData.ClassUUID == "2ae1476b-f3f8-4aa1-8923-39b91c1796ce" then
                    
                    -- 检查子职业（猫派猎魔人 UUID）
                    if classData.SubClassUUID ~= nil and classData.SubClassUUID == "2c67a669-0ef8-4431-a869-8bfdabd6fd73" then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function InMelee(attacker, defender)
  if Osi.GetDistanceTo(attacker, defender) < 4 then
      return true
  end
  return false
end

--=============================== ON SESSION LOAD ===============================

local function OnSessionLoaded()
  -- Register listener for TurnEnded (end of each round)
  Ext.Osiris.RegisterListener("TurnEnded", 1, "after", function (_)
      -- Refresh resources at the end of the turn
      ResourceRefresh()
  end)

  -- Register listener for TurnStarted (start of each round)
  Ext.Osiris.RegisterListener("TurnStarted", 1, "after", function (_)
      -- Refresh resources at the start of the turn
      ResourceRefresh()
  end)

  -- Register listener for when a character is attacked (defender)
  Ext.Osiris.RegisterListener("AttackedBy", 7, "before", function (defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
      -- Refresh resources when a character is attacked
      ResourceRefresh()

      _P("--------------Attack Started------------------")

        -- 攻击者是猎魔人，并且攻击目标是角色
        if attackerOwner ~= nil then
            if IsWitcher(attackerOwner) == true and Osi.IsCharacter(defender) == 1 then
                UpdateVitality(attackerOwner)
            end
        end

        -- 防御者是猎魔人，并且自身是角色（避免物品被误判成“猎魔人”）
        if Osi.IsCharacter(defender) == 1 and IsWitcher(defender) == true then
            UpdateVitality(defender)
        end

      _P("--------------Attack Done-----------------------------------")
  end)

  -- Register listener for when a character casts a spell
  Ext.Osiris.RegisterListener("CastSpell", 5, "before", function (caster, spell, _, _, _)
      -- Refresh resources when a spell is cast
      ResourceRefresh()
  end)

  -- Register listener for when a character enters combat
  Ext.Osiris.RegisterListener("EnteredCombat", 2, "after", function (character, combatguid)
      -- Refresh resources after entering combat
      ResourceRefresh()

      -- If the character is a Witcher, update vitality
      if IsWitcher(character) == true then
          UpdateVitality(character)
      end
  end)

  -- Register listener for when a character equips an item (e.g., weapons)
  Ext.Osiris.RegisterListener("Equipped", 2, "before", function (item, character)
      -- Refresh resources when an item is equipped
      ResourceRefresh()

      -- If the character is a Witcher and has Titan Grip, modify weapon properties
      if IsWitcher(character) == true then
          if Osi.HasPassive(character, "Warrior_Titan_Grip") == 1 then
              -- Modify the weapon (e.g., RemoveTwoHander function)
              RemoveTwoHander(item)
          end
      end
  end)

  -- Register listener for when a character unequips an item
  Ext.Osiris.RegisterListener("Unequipped", 2, "before", function (item, character)
      -- Refresh resources when an item is unequipped
      ResourceRefresh()
  end)
end

-- Function to update the Vitality of a character (either attacker or defender)
function UpdateVitality(character)
  local player = Ext.Entity.Get(character)
  if not player or not player.ActionResources then return end
  local currentVitality = player.ActionResources.Resources["0ea5e366-0f9a-413e-8085-28a5f4269a94"]["1"].Amount  -- Get current vitality
  local maxVitality = player.ActionResources.Resources["0ea5e366-0f9a-413e-8085-28a5f4269a94"]["1"].MaxAmount -- Get max vitality

  -- If current vitality is less than max, increase vitality by 1
  if currentVitality < maxVitality then
      player.ActionResources.Resources["0ea5e366-0f9a-413e-8085-28a5f4269a94"]["1"].Amount = currentVitality + 1
      Ext.Entity.Get(character):Replicate("ActionResources")  -- Synchronize to clients
      _P("Vitality increased to: " .. player.ActionResources.Resources["0ea5e366-0f9a-413e-8085-28a5f4269a94"]["1"].Amount)
  end
end

-- Function to refresh resources for characters (this can include Vitality, Bravery, etc.)
function ResourceRefresh()
  -- Refresh resources here (this could be a simple call to UpdateVitality or other logic)
  -- Currently calling UpdateVitality for all attackers and defenders during their turn
  _P("Resource refresh triggered")
end

function RefreshVitalityStatus()
    local player = Osi.GetHostCharacter()

    if IsWitcher(player) == true then
        local rage = math.floor(GetVitality(player))

        -- 清除旧状态
        Osi.RemoveStatus(player, "Witcher_Vitality_Track")

        -- 应用新的 Rage 跟踪状态（持续时间 = Rage × 6 秒）
        Osi.ApplyStatus(player, "Witcher_Vitality_Track", rage * 6)
        _P("Resource refresh triggered")
    end
end

Ext.Osiris.RegisterListener("TurnEnded", 1, "after", function (_)
    RefreshVitalityStatus()
end)

Ext.Osiris.RegisterListener("TurnStarted", 1, "after", function (_)
    RefreshVitalityStatus()
end)

Ext.Osiris.RegisterListener("EnteredCombat", 2, "after", function (character, combatguid)
    RefreshVitalityStatus()
end)

Ext.Osiris.RegisterListener("FleeFromCombat", 2, "after", function (character, combatguid)
    RefreshVitalityStatus()
end)

Ext.Osiris.RegisterListener("Equipped", 2, "before", function (item, character)
    RefreshVitalityStatus()
end)

Ext.Osiris.RegisterListener("Unequipped", 2, "before", function (item, character)
    RefreshVitalityStatus()
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "before", function (caster, spell, _, _, _)
    RefreshVitalityStatus()
end)



Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)

------------------------------------------------------------------------------------------------------------------------

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, _, _)
  if status == "TawnyOwl" then
    local entity = Ext.Entity.Get(target)
    if entity and entity.ActionResources then
      local res = entity.ActionResources.Resources["0ea5e366-0f9a-413e-8085-28a5f4269a94"]
      if res then
        local max = res["1"].MaxAmount or 0
        local restore = math.floor(max * 0.5)  -- 恢复 50%
        res["1"].Amount = math.min(res["1"].Amount + restore, max)
        entity:Replicate("ActionResources")
      end
    end
  end
end)

--------------------------------------------------------------------------------------------------------------------

Ext.Osiris.RegisterListener("TurnStarted", 1, "after", function(char)
  if Osi.HasActiveStatus(char, "Leshen") == 1 then
    local entity = Ext.Entity.Get(char)
    if entity and entity.ActionResources then
      local res = entity.ActionResources.Resources["0ea5e366-0f9a-413e-8085-28a5f4269a94"]
      if res then
        local max = res["1"].MaxAmount or 0
        local current = res["1"].Amount or 0
        local regen = math.floor(max * 0.08)
        local newAmount = math.min(current + regen, max)
        res["1"].Amount = newAmount

        entity:Replicate("ActionResources")
        _P("[DEBUG] Leshen restored " .. regen .. " vitality to " .. char)
      end
    end
  end
end)


-----------------------------------------------------------------------------------------------------------------

--The listener to get the position on turn start of Spring-Heeled Assassin
Ext.Osiris.RegisterListener("TurnStarted", 1, "before", function(shade)
    if (HasPassive(shade,"Target_ShadowStrike_Cat_Passvie") == 1) then
        local posatstartx,posatstarty,posatstartz = Osi.GetPosition(shade)
        Ext.Entity.Get(shade).Vars.Lu_Shde_SpringHeeledAssStartPos = {posatstartx,posatstarty,posatstartz}
    end
end)

--The listener to apply the status of Spring-Heeled Assassin
Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "before", function(shade, _, _, _, _)
    if HasPassive(shade,"Target_ShadowStrike_Cat_Passvie") == 1 then
        Lu_Shde_SpringHeeledAssApply(shade)
    end
end)

function Lu_Shde_SpringHeeledAssApply(shade)
    local posatturnstartx = Ext.Entity.Get(shade).Vars.Lu_Shde_SpringHeeledAssStartPos[1]
    local posatturnstarty = Ext.Entity.Get(shade).Vars.Lu_Shde_SpringHeeledAssStartPos[2]
    local posatturnstartz = Ext.Entity.Get(shade).Vars.Lu_Shde_SpringHeeledAssStartPos[3]
    for k, v in pairs(Osi.DB_Is_InCombat:Get(nil, Osi.CombatGetGuidFor(Ext.Entity.Get(shade).Uuid.EntityUuid))) do
        local targetpostx,targetposty,targetpostz = Osi.GetPosition(v[1])
        local distance = Ext.Math.Length({targetpostx-posatturnstartx,targetposty-posatturnstarty,targetpostz-posatturnstartz})
        if (3 <= distance and distance <= 6) then
            Osi.ApplyStatus(v[1],"ShadowStrike_Cat_TECHNICAL_1_200029",5.0,1)
        elseif (6 < distance and distance <= 9) then
            Osi.ApplyStatus(v[1],"ShadowStrike_Cat_TECHNICAL_2_200030",5.0,1)
        elseif (9 < distance and distance <= 12) then
            Osi.ApplyStatus(v[1],"ShadowStrike_Cat_TECHNICAL_3_200031",5.0,1)
        elseif (12 < distance and distance <= 15) then
            Osi.ApplyStatus(v[1],"ShadowStrike_Cat_TECHNICAL_4_200032",5.0,1)
        elseif (15 < distance) then
            Osi.ApplyStatus(v[1],"ShadowStrike_Cat_TECHNICAL_5_200033",5.0,1)
        else
            Osi.RemoveStatus(v[1],"ShadowStrike_Cat_TECHNICAL_1_200029")
            Osi.RemoveStatus(v[1],"ShadowStrike_Cat_TECHNICAL_2_200030")
            Osi.RemoveStatus(v[1],"ShadowStrike_Cat_TECHNICAL_3_200031")
            Osi.RemoveStatus(v[1],"ShadowStrike_Cat_TECHNICAL_4_200032")
            Osi.RemoveStatus(v[1],"ShadowStrike_Cat_TECHNICAL_5_200033")
        end
    end
end



Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "before", function (shade, target, spell, _, _, _)
        -- 如果目标是自己，直接跳过（避免自我增益触发）
    if shade == target then
        return
    end

    -- 如果是友军目标，跳过（避免给队友上 buff 时触发）
    if Osi.IsAlly(shade, target) == 1 then
        return
    end
    -- 💡 若为黑名单技能标记的攻击，跳过威慑判定
    if Osi.HasActiveStatus(shade, "IGNORE_INTIMIDATION") == 1 then
        _P("[DEBUG] Attacker has IGNORE_INTIMIDATION status, skipping intimidation logic.")
        return
    end

    if (HasPassive(shade,"Bear_Intimidation") == 1) then
        if spell == "Shout_Roar_Bear_witcher" then return end
        for k, v in pairs(Osi.DB_Is_InCombat:Get(nil, Osi.CombatGetGuidFor(Ext.Entity.Get(shade).Uuid.EntityUuid))) do
            if (v[1] ~= target) then 
                Osi.RemoveStatus(v[1],"EXQUISITE_HUNTER_STAGE_1_200017")
                Osi.RemoveStatus(v[1],"EXQUISITE_HUNTER_STAGE_2_200018")
                Osi.RemoveStatus(v[1],"EXQUISITE_HUNTER_STAGE_3_200019")
            end
            if (v[1] == target and Osi.HasActiveStatus(shade,"EXQUISITE_HUNTER_TECHNICAL_200020") ~= 1) then
                if (Osi.HasActiveStatus(target,"EXQUISITE_HUNTER_STAGE_2_200018") == 1) then
                    Osi.ApplyStatus(v[1],"EXQUISITE_HUNTER_STAGE_3_200019",-1.0,1,shade)
                end
                if (Osi.HasActiveStatus(target,"EXQUISITE_HUNTER_STAGE_1_200017") == 1) then
                    Osi.ApplyStatus(v[1],"EXQUISITE_HUNTER_STAGE_2_200018",-1.0,1,shade)
                end
                if (Osi.HasActiveStatus(target,"EXQUISITE_HUNTER_STAGE_2_200018") ~= 1 and Osi.HasActiveStatus(target,"EXQUISITE_HUNTER_STAGE_3_200019") ~= 1) then
                    Osi.ApplyStatus(v[1],"EXQUISITE_HUNTER_STAGE_1_200017",-1.0,1,shade)
                end
                -- 额外：第二阶段自动恐惧
                if Osi.HasActiveStatus(target, "EXQUISITE_HUNTER_STAGE_2_200018") == 1 then
                    Osi.ApplyStatus(target, "FRIGHTENED", 18.0, 1, shade)
                end
            end
        end
    end
end)

Ext.Osiris.RegisterListener("CastSpell",5, "after", function(caster, spell,_,_,_)
        --check if Execute was casted    
        if spell ==  "Target_Cat_Execute" then
            _P("Used Execute")
            --Use all Rage
            Ext.Entity.Get(GetHostCharacter()).ActionResources.Resources["0ea5e366-0f9a-413e-8085-28a5f4269a94"]["1"].Amount = 0
            Ext.Entity.Get(caster):Replicate("ActionResources")
        end
    end)


Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, _, _, _)
    -- 检查是否是你的技能
    if spell == "Projectile_ChainLightning_Enpower1" then
        -- 先拿到角色实体
        local entity = Ext.Entity.Get(caster)
        if entity and entity.ActionResources and entity.ActionResources.Resources then
            -- Vitality 的 UUID
            local vitalityUUID = "0ea5e366-0f9a-413e-8085-28a5f4269a94"

            local vitalityRes = entity.ActionResources.Resources[vitalityUUID]
            if vitalityRes and vitalityRes["1"] then
                local current = vitalityRes["1"].Amount or 0
                -- 保留一半，向下取整
                local newAmount = math.floor(current * 0.5)
                vitalityRes["1"].Amount = newAmount
                -- 通知游戏刷新
                entity:Replicate("ActionResources")
            end
        end
    end
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, _, _, _)
    -- 第1段：Griffin_Thermora1
    if spell == "Target_Griffin_Thermora1" then
        -- 50% 概率进入第二段
        if math.random() < 0.7 then
            -- 添加状态1
            Osi.ApplyStatus(caster, "Griffin_Fire_magic_level1", 6.0, 100, caster)
        end
    end
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, _, _, _)
    -- 第1段：Griffin_Thermora1
    if spell == "Zone_Griffin_Thermora2" then
        -- 30% 概率进入第二段
        if math.random() < 0.3 then
            -- 添加状态1
            Osi.ApplyStatus(caster, "Griffin_Fire_magic_level2", 6.0, 100, caster)
        end
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status == "PhaseSpide_decoction_1" and IsViperWitcher(target) then
        -- 直接用覆盖机制，不需要手动 Remove
        Osi.RemoveStatus(target, "PhaseSpide_decoction_1")
        Osi.ApplyStatus(target, "PhaseSpide_decoction_2", -1, 100, target)
    end
end)


Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status == "Owlbear_decoction_1" and IsBearWitcher(target) then
        -- 直接用覆盖机制，不需要手动 Remove
        Osi.RemoveStatus(target, "Owlbear_decoction_1")
        Osi.ApplyStatus(target, "Owlbear_decoction_2", -1, 100, target)
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status == "Ogre_decoction_1" and IsBearWitcher(target) then
        -- 直接用覆盖机制，不需要手动 Remove
        Osi.RemoveStatus(target, "Ogre_decoction_1")
        Osi.ApplyStatus(target, "Ogre_decoction_2", -1, 100, target)
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status == "Werewolf_decoction_1" and IsWolfWitcher(target) then
        -- 直接用覆盖机制，不需要手动 Remove
        Osi.RemoveStatus(target, "Werewolf_decoction_1")
        Osi.ApplyStatus(target, "Werewolf_decoction_2", -1, 100, target)
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status == "Hobgoblin_decoction_1" and IsCatWitcher(target) then
        -- 直接用覆盖机制，不需要手动 Remove
        Osi.RemoveStatus(target, "Hobgoblin_decoction_1")
        Osi.ApplyStatus(target, "Hobgoblin_decoction_2", -1, 100, target)
    end
end)