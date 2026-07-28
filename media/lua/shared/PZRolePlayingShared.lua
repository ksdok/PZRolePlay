PZRolePlayingShared = PZRolePlayingShared or {}

if PZRolePlayingShared.DEBUG == nil then
    PZRolePlayingShared.DEBUG = true
end

function PZRolePlayingShared.log(module, message)
    if PZRolePlayingShared.DEBUG ~= true then return end
    print("[PZRolePlaying][" .. tostring(module) .. "] " .. tostring(message))
end

local NOW_SOURCE = nil

local ROLE_CARRY_CAPACITY = {
    builder = 90,
    demolisseur = 60,
    invincible = 90,
    rambo = 60,
    samourai = 60,
}

function PZRolePlayingShared.round(value)
    if value == nil then return 0 end
    if value >= 0 then
        return math.floor(value + 0.5)
    end
    return math.ceil(value - 0.5)
end

function PZRolePlayingShared.getNowSeconds()
    if getTimestamp ~= nil then
        local timestamp = getTimestamp()
        if timestamp ~= nil then
            if NOW_SOURCE ~= "getTimestamp" then
                NOW_SOURCE = "getTimestamp"
                print("[PZRolePlaying] getNowSeconds -> getTimestamp")
            end
            return math.floor(timestamp)
        end
    end

    if os ~= nil and os.time ~= nil then
        if NOW_SOURCE ~= "os.time" then
            NOW_SOURCE = "os.time"
            print("[PZRolePlaying] getNowSeconds -> os.time")
        end
        return os.time()
    end

    if getGameTime ~= nil then
        local gameTime = getGameTime()
        if gameTime ~= nil and gameTime.getWorldAgeHours ~= nil then
            if NOW_SOURCE ~= "getGameTime" then
                NOW_SOURCE = "getGameTime"
                print("[PZRolePlaying] getNowSeconds -> getGameTime:getWorldAgeHours")
            end
            return math.floor(gameTime:getWorldAgeHours() * 3600)
        end
    end

    if NOW_SOURCE ~= "zero" then
        NOW_SOURCE = "zero"
        print("[PZRolePlaying] WARN: getNowSeconds aucun timer disponible, retourne 0")
    end
    return 0
end

function PZRolePlayingShared.applyCarryProfile(player, roleKey)
    if player == nil then return end

    local carryCapacity = ROLE_CARRY_CAPACITY[roleKey]
    local unlimitedCarry = carryCapacity ~= nil

    if player.setUnlimitedCarry ~= nil then
        player:setUnlimitedCarry(unlimitedCarry)
    end

    if not unlimitedCarry then return end

    if player.getMaxWeightBase ~= nil and player.setMaxWeightBase ~= nil then
        local baseWeight = player:getMaxWeightBase() or 0
        if baseWeight < carryCapacity then
            player:setMaxWeightBase(carryCapacity)
        end
    end

    if player.getMaxWeight ~= nil and player.setMaxWeight ~= nil then
        local maxWeight = player:getMaxWeight() or 0
        if maxWeight < carryCapacity then
            player:setMaxWeight(carryCapacity)
        end
    end

    if player.setMaxWeightDelta ~= nil then
        player:setMaxWeightDelta(0)
    end
end

function PZRolePlayingShared.addItemsToContainer(container, itemId, count)
    if container == nil or itemId == nil or count == nil or count <= 0 then return end
    for _ = 1, count do
        container:AddItem(itemId)
    end
end

function PZRolePlayingShared.buildItemCounts(items)
    local counts = {}
    if items == nil then return counts end
    for _, itemDef in ipairs(items) do
        local itemId = itemDef[1]
        local count = itemDef[2] or 1
        counts[itemId] = (counts[itemId] or 0) + count
    end
    return counts
end

function PZRolePlayingShared.addRoleItems(inv, bagItem, bagItemId, items, bagContents)
    if inv == nil or items == nil then return end
    local bagContainer = bagItem and bagItem:getItemContainer() or nil
    local bagCounts = PZRolePlayingShared.buildItemCounts(bagContents)
    for _, itemDef in ipairs(items) do
        local itemId = itemDef[1]
        local totalCount = itemDef[2] or 1
        if itemId ~= bagItemId then
            local bagCount = 0
            if bagContainer ~= nil and bagCounts[itemId] ~= nil then
                bagCount = math.min(totalCount, bagCounts[itemId])
            end
            local invCount = totalCount - bagCount
            if invCount > 1 then
                inv:AddItems(itemId, invCount)
            elseif invCount == 1 then
                inv:AddItem(itemId)
            end
            PZRolePlayingShared.addItemsToContainer(bagContainer, itemId, bagCount)
        end
    end
end

function PZRolePlayingShared.applyRoleStats(player, stats)
    if player == nil then return end
    local playerStats = player:getStats()
    playerStats:setPanic(30)
    playerStats:setHunger(0.2)
    playerStats:setThirst(0.2)
    playerStats:setFatigue(0)
    if stats == nil then return end
    if stats.endurance ~= nil then playerStats:setEndurance(stats.endurance) end
    if stats.panic ~= nil then playerStats:setPanic(stats.panic) end
    if stats.fatigue ~= nil then playerStats:setFatigue(stats.fatigue) end
    if stats.hunger ~= nil then playerStats:setHunger(stats.hunger) end
    if stats.thirst ~= nil then playerStats:setThirst(stats.thirst) end
end

function PZRolePlayingShared.isPassivePerk(perk)
    return perk == Perks.Strength or perk == Perks.Fitness
end

function PZRolePlayingShared.applyPerkLevel(player, perk, level)
    if player == nil or perk == nil or level == nil then return end
    local xp = player:getXp()
    xp:setXPToLevel(perk, level)
    if PZRolePlayingShared.isPassivePerk(perk) and player.setPerkLevelDebug ~= nil then
        player:setPerkLevelDebug(perk, level)
    end
    if player.getPerkLevel ~= nil then
        local currentLevel = player:getPerkLevel(perk)
        if currentLevel ~= nil and player.LevelPerk ~= nil then
            while currentLevel < level do
                player:LevelPerk(perk, false)
                local newLevel = player:getPerkLevel(perk)
                if newLevel == nil or newLevel <= currentLevel then break end
                currentLevel = newLevel
            end
        end
        if currentLevel ~= nil and player.LoseLevel ~= nil then
            while currentLevel > level do
                player:LoseLevel(perk)
                local newLevel = player:getPerkLevel(perk)
                if newLevel == nil or newLevel >= currentLevel then break end
                currentLevel = newLevel
            end
        end
    end
    xp:setXPToLevel(perk, level)
end

function PZRolePlayingShared.applyManualTeleportState(player, x, y, z)
    player:setX(x)
    player:setY(y)
    player:setZ(z)
    if player.setLx ~= nil then player:setLx(x) end
    if player.setLy ~= nil then player:setLy(y) end
    if player.setLz ~= nil then player:setLz(z) end
    if player.setNx ~= nil then player:setNx(x) end
    if player.setNy ~= nil then player:setNy(y) end
    if player.setScriptnx ~= nil then player:setScriptnx(x) end
    if player.setScriptny ~= nil then player:setScriptny(y) end
    local cell = getCell ~= nil and getCell() or nil
    local square = cell ~= nil and cell.getGridSquare ~= nil and cell:getGridSquare(x, y, z) or nil
    if square ~= nil then
        if player.setCurrent ~= nil then player:setCurrent(square) end
        if player.setLast ~= nil then player:setLast(square) end
    end
    if player.setMovingSquareNow ~= nil then player:setMovingSquareNow() end
    if player.ensureOnTile ~= nil then player:ensureOnTile() end
end

local function forEachContainerItemRecursive(container, callback)
    if container == nil or callback == nil or container.getItems == nil then return end

    local items = container:getItems()
    if items == nil then return end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item ~= nil then
            callback(item)

            local childContainer = item.getItemContainer and item:getItemContainer() or nil
            if childContainer ~= nil then
                forEachContainerItemRecursive(childContainer, callback)
            end
        end
    end
end

PZRolePlayingShared.forEachContainerItemRecursive = forEachContainerItemRecursive

local function fillAmmoItem(item)
    if item == nil then return end

    if item.isRanged ~= nil and item:isRanged() then
        local maxAmmo = 0
        if item.getMaxAmmo ~= nil then maxAmmo = item:getMaxAmmo() or 0 end
        if maxAmmo > 0 and item.setCurrentAmmoCount ~= nil then
            item:setCurrentAmmoCount(maxAmmo)
        end
        if item.getMagazineType ~= nil and item.setContainsClip ~= nil then
            local magazineType = item:getMagazineType()
            if magazineType ~= nil and magazineType ~= "" then
                item:setContainsClip(true)
            end
        end
        if item.haveChamber ~= nil and item:haveChamber() and item.setRoundChambered ~= nil then
            item:setRoundChambered(true)
        elseif item.setRoundChambered ~= nil and item.getCurrentAmmoCount ~= nil then
            item:setRoundChambered((item:getCurrentAmmoCount() or 0) > 0)
        end
        if item.setSpentRoundChambered ~= nil then
            item:setSpentRoundChambered(false)
        end
        return
    end

    if item.getMaxAmmo ~= nil and item.setCurrentAmmoCount ~= nil then
        local maxAmmo = item:getMaxAmmo() or 0
        if maxAmmo > 0 then
            item:setCurrentAmmoCount(maxAmmo)
        end
    end
end

PZRolePlayingShared.fillAmmoItem = fillAmmoItem

function PZRolePlayingShared.primeRoleLoadout(inv)
    if inv == nil then return end
    forEachContainerItemRecursive(inv, fillAmmoItem)
end

function PZRolePlayingShared.resolveSecondaryEquipItem(inv, equipped, primary)
    if inv == nil or equipped == nil then return nil end

    if equipped.secondary then
        if primary ~= nil and equipped.secondary == equipped.primary then
            return primary
        end
        return inv:FindAndReturn(equipped.secondary)
    end

    if primary ~= nil and primary.isTwoHandWeapon ~= nil and primary:isTwoHandWeapon() then
        return primary
    end

    return nil
end

function PZRolePlayingShared.equipRoleItems(player, inv, equipped)
    if player == nil or inv == nil or equipped == nil then return end

    local primary = nil
    if equipped.primary then
        primary = inv:FindAndReturn(equipped.primary)
        if primary then player:setPrimaryHandItem(primary) end
    end

    local secondary = PZRolePlayingShared.resolveSecondaryEquipItem(inv, equipped, primary)
    if secondary ~= nil then
        player:setSecondaryHandItem(secondary)
    end

    if equipped.bag then
        local bag = inv:FindAndReturn(equipped.bag)
        if bag then
            local bodyLocation = bag.getBodyLocation ~= nil and bag:getBodyLocation() or nil
            if bodyLocation ~= nil and bodyLocation ~= "" and bodyLocation ~= "Back" then
                player:setWornItem(bodyLocation, bag)
            else
                player:setClothingItem_Back(bag)
            end
        end
    end

    if equipped.clothes then
        for _, clothId in ipairs(equipped.clothes) do
            local cloth = inv:FindAndReturn(clothId)
            if cloth and cloth:getBodyLocation() ~= nil then
                player:setWornItem(cloth:getBodyLocation(), cloth)
            end
        end
    end
end
