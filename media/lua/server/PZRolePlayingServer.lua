require "PZRolePlayingRoles"
require "PZRolePlayingShared"

PZRolePlayingServer = PZRolePlayingServer or {}

local MODULE = PZRolePlayingRoles.MODULE or "PZRolePlaying"
local ROLE_KEY = PZRolePlayingRoles.MOD_DATA_ROLE_KEY or "PZRP_role"

local Server = {
    assignedRoles = {},
    roleLoadouts = {},
}

local applyCarryProfile = PZRolePlayingShared.applyCarryProfile
local applyRoleStats = PZRolePlayingShared.applyRoleStats
local applyPerkLevel = PZRolePlayingShared.applyPerkLevel

local function logServer(message)
    PZRolePlayingShared.log("Server", message)
end

local function getRoleDefs()
    return PZRolePlayingRoles.getActiveRoleDefs()
end

local function getRoleNames()
    return PZRolePlayingRoles.getActiveRoleNames()
end

local function sendRoleAssigned(username, roleKey, options)
    sendServerCommand(MODULE, "RoleAssigned", {
        username = username,
        role = roleKey,
        roleName = getRoleNames()[roleKey] or roleKey,
        applyItems = options ~= nil and options.applyItems == true,
        brita = PZRolePlayingRoles.isBritaInstalled(),
    })
end

local function sendRoleUnavailable(username, text)
    sendServerCommand(MODULE, "RoleUnavailable", {
        username = username,
        text = text,
    })
end

local function applyRole(player, roleKey)
    if player == nil or roleKey == nil then return false end

    local defs = getRoleDefs()
    local def = defs[roleKey]
    if def == nil then return false end

    local username = player:getUsername()
    local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
    modData[ROLE_KEY] = roleKey

    if username ~= nil and Server.roleLoadouts[username] == roleKey then
        applyCarryProfile(player, roleKey)
        return false
    end

    for _, skillDef in ipairs(def.skills or {}) do
        applyPerkLevel(player, skillDef[1], skillDef[2])
    end
    applyRoleStats(player, def.stats)
    applyCarryProfile(player, roleKey)

    if username ~= nil then
        Server.roleLoadouts[username] = roleKey
        Server.assignedRoles[username] = roleKey
    end

    return true
end

local function restoreAssignedRole(player)
    if player == nil then return nil end

    local username = player:getUsername()
    if username == nil then return nil end

    local roleKey = Server.assignedRoles[username]
    if roleKey == nil then
        local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
        local persistedRole = modData[ROLE_KEY]
        local defs = getRoleDefs()
        if persistedRole ~= nil and defs[persistedRole] ~= nil then
            roleKey = persistedRole
            Server.assignedRoles[username] = persistedRole
        end
    end

    if roleKey ~= nil then
        applyRole(player, roleKey)
        return roleKey
    end

    return nil
end

local function onClientCommand(module, command, player, data)
    if module ~= MODULE then return end

    local username = player and player:getUsername() or nil
    if username == nil then return end

    if command == "RolePickerReady" then
        local roleKey = restoreAssignedRole(player)
        if roleKey ~= nil then
            sendRoleAssigned(username, roleKey, {
                applyItems = false,
            })
            return
        end

        sendServerCommand(MODULE, "OpenRolePicker", {
            username = username,
            brita = PZRolePlayingRoles.isBritaInstalled(),
        })
        return
    end

    if command ~= "ChooseRole" then return end

    local existingRole = restoreAssignedRole(player)
    if existingRole ~= nil then
        sendRoleAssigned(username, existingRole, {
            applyItems = false,
        })
        return
    end

    local defs = getRoleDefs()
    local roleKey = data and data.roleKey or nil
    if roleKey == nil or defs[roleKey] == nil then
        sendRoleUnavailable(username, "Role invalide.")
        return
    end

    local granted = applyRole(player, roleKey)
    if granted then
        logServer("Role assigne: " .. tostring(username) .. " = " .. tostring(getRoleNames()[roleKey] or roleKey))
    end

    sendRoleAssigned(username, roleKey, {
        applyItems = granted,
    })
end
Events.OnClientCommand.Add(onClientCommand)

local function resetState(eventName)
    Server.assignedRoles = {}
    Server.roleLoadouts = {}
    PZRolePlayingRoles.clearBritaOverride()
    PZRolePlayingRoles.invalidateBritaCache()
    print("[PZRolePlaying] server " .. tostring(eventName) .. " - reset etat serveur")
end

Events.OnServerStarted.Add(function() resetState("OnServerStarted") end)
Events.OnGameStart.Add(function() resetState("OnGameStart") end)
