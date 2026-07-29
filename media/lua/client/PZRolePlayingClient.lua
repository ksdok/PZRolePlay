require "PZRolePlayingRolePicker"
require "PZRolePlayingRoles"
require "PZRolePlayingShared"

PZRolePlayingClient = PZRolePlayingClient or {}

local MODULE = PZRolePlayingRoles.MODULE or "PZRolePlaying"
local ROLE_KEY = PZRolePlayingRoles.MOD_DATA_ROLE_KEY or "PZRP_role"
local LOCAL_APPLIED_KEY = PZRolePlayingRoles.MOD_DATA_LOCAL_APPLIED_KEY or "PZRP_localRoleApplied"

local roleRequestSent = false
local soloPickerFallbackAt = nil
local mpRolePickerRetryAt = nil
local retryTickRegistered = false

local getNowSeconds = PZRolePlayingShared.getNowSeconds
local applyCarryProfile = PZRolePlayingShared.applyCarryProfile
local primeRoleLoadout = PZRolePlayingShared.primeRoleLoadout
local equipRoleItems = PZRolePlayingShared.equipRoleItems
local addRoleItems = PZRolePlayingShared.addRoleItems
local applyRoleStats = PZRolePlayingShared.applyRoleStats
local applyPerkLevel = PZRolePlayingShared.applyPerkLevel

local function logClient(message)
    PZRolePlayingShared.log("Client", message)
end

local function isSinglePlayerRuntime()
    if isClient ~= nil then
        return not isClient()
    end
    if getOnlinePlayers ~= nil then
        local onlinePlayers = getOnlinePlayers()
        return onlinePlayers == nil or onlinePlayers:size() == 0
    end
    return true
end

local function showRoleAssigned(roleName)
    if HaloTextHelper ~= nil and HaloTextHelper.addTextWithArrow ~= nil and HaloTextHelper.getColorGreen ~= nil then
        HaloTextHelper.addTextWithArrow(getPlayer(), "Role: " .. tostring(roleName), true, HaloTextHelper.getColorGreen())
    end
end

local function ensureRetryTickRegistered()
    if retryTickRegistered then return end
    Events.OnTick.Add(PZRolePlayingClient.TickRolePickerFallback)
    retryTickRegistered = true
end

local function unregisterRetryTick()
    if not retryTickRegistered then return end
    if Events.OnTick.Remove ~= nil then
        Events.OnTick.Remove(PZRolePlayingClient.TickRolePickerFallback)
    end
    retryTickRegistered = false
end

function PZRolePlayingClient.applyRoleLocally(player, roleKey)
    if player == nil or roleKey == nil then return false end

    local defs = PZRolePlayingRoles.getActiveRoleDefs()
    local def = defs[roleKey]
    if def == nil then return false end

    local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
    if modData[LOCAL_APPLIED_KEY] == roleKey then
        logClient("applyRoleLocally SKIP (déjà appliqué) role=" .. tostring(roleKey))
        return false
    end
    logClient("applyRoleLocally START role=" .. tostring(roleKey) .. " def.equipped=" .. tostring(def.equipped ~= nil))

    local inv = player:getInventory()
    local roleBag = nil

    if def.equipped and def.equipped.bag then
        roleBag = inv:AddItem(def.equipped.bag)
        logClient("bag créé " .. tostring(def.equipped.bag) .. " -> " .. tostring(roleBag ~= nil))
    end

    addRoleItems(inv, roleBag, def.equipped and def.equipped.bag or nil, def.items, def.bagContents)
    primeRoleLoadout(inv)

    for _, skillDef in ipairs(def.skills or {}) do
        applyPerkLevel(player, skillDef[1], skillDef[2])
    end

    equipRoleItems(player, inv, def.equipped)
    applyRoleStats(player, def.stats)
    applyCarryProfile(player, roleKey)

    modData[ROLE_KEY] = roleKey
    modData[LOCAL_APPLIED_KEY] = roleKey

    showRoleAssigned(PZRolePlayingRoles.getRoleName(roleKey))
    logClient("applyRoleLocally termine - role=" .. tostring(roleKey))
    return true
end

function PZRolePlayingClient.chooseRoleLocal(roleKey)
    local player = getPlayer()
    if player == nil or roleKey == nil then return false end

    local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
    if modData[ROLE_KEY] ~= nil then
        PZRolePlayingRolePicker.pendingRole = nil
        PZRolePlayingRolePicker.setStatus("Role deja choisi pour cette partie.")
        return false
    end

    local applied = PZRolePlayingClient.applyRoleLocally(player, roleKey)
    if applied then
        PZRolePlayingRolePicker.close()
        return true
    end

    PZRolePlayingRolePicker.pendingRole = nil
    PZRolePlayingRolePicker.setStatus("Echec de l'application locale du role.")
    return false
end

function PZRolePlayingClient.TickRolePickerFallback()
    local player = getPlayer()
    if player == nil then return end

    local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
    if modData[ROLE_KEY] ~= nil then
        soloPickerFallbackAt = nil
        mpRolePickerRetryAt = nil
        unregisterRetryTick()
        return
    end

    if PZRolePlayingRolePicker.isVisible() then
        return
    end

    local now = getNowSeconds()
    if isSinglePlayerRuntime() then
        if soloPickerFallbackAt == nil then
            unregisterRetryTick()
            return
        end
        if now >= soloPickerFallbackAt then
            soloPickerFallbackAt = now + 3
            PZRolePlayingRolePicker.openLocal()
        end
        return
    end

    if mpRolePickerRetryAt == nil then
        unregisterRetryTick()
        return
    end

    if now >= mpRolePickerRetryAt then
        sendClientCommand(MODULE, "RolePickerReady", {
            username = player:getUsername(),
        })
        mpRolePickerRetryAt = now + 3
    end
end

local function requestRolePicker()
    local player = getPlayer()
    if player == nil then return end

    local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
    if modData[ROLE_KEY] ~= nil then
        logClient("requestRolePicker ignore - role deja choisi: " .. tostring(modData[ROLE_KEY]))
        return
    end
    if roleRequestSent then return end

    roleRequestSent = true

    if isSinglePlayerRuntime() then
        soloPickerFallbackAt = getNowSeconds() + 3
        ensureRetryTickRegistered()
        return
    end

    mpRolePickerRetryAt = getNowSeconds() + 3
    ensureRetryTickRegistered()
    sendClientCommand(MODULE, "RolePickerReady", {
        username = player:getUsername(),
    })
end

local function onCreatePlayer()
    requestRolePicker()
end
Events.OnCreatePlayer.Add(onCreatePlayer)

local function onGameStart()
    roleRequestSent = false
    PZRolePlayingRoles.clearBritaOverride()
    PZRolePlayingRoles.invalidateBritaCache()
    requestRolePicker()
end
Events.OnGameStart.Add(onGameStart)

local function isLocalUser(data)
    local player = getPlayer()
    return player ~= nil and data ~= nil and data.username == player:getUsername()
end

local function onServerCommand(module, command, data)
    if module ~= MODULE then return end

    if command == "OpenRolePicker" then
        if not isLocalUser(data) then return end
        roleRequestSent = false
        if data ~= nil and data.brita ~= nil then
            PZRolePlayingRoles.setBritaOverride(data.brita)
        end
        local player = getPlayer()
        if player ~= nil then
            local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
            if modData[ROLE_KEY] == nil then
                PZRolePlayingRolePicker.open("network")
            end
        end
        return
    end

    if command == "RoleAssigned" then
        if not isLocalUser(data) then return end
        if data ~= nil and data.brita ~= nil then
            PZRolePlayingRoles.setBritaOverride(data.brita)
        end

        local player = getPlayer()
        if player ~= nil then
            if data.applyItems == true then
                PZRolePlayingClient.applyRoleLocally(player, data.role)
            end
            local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
            modData[ROLE_KEY] = data.role
        end

        roleRequestSent = false
        PZRolePlayingRolePicker.close()
        showRoleAssigned(data.roleName or data.role)
        return
    end

    if command == "RoleDenied" or command == "RoleUnavailable" then
        if not isLocalUser(data) then return end
        roleRequestSent = false
        PZRolePlayingRolePicker.pendingRole = nil
        PZRolePlayingRolePicker.setStatus(data and data.text or "Choix refuse.")
    end
end
Events.OnServerCommand.Add(onServerCommand)
