require "PZRolePlayingShared"
require "PZRolePlayingRolesVanilla"
require "PZRolePlayingRolesBrita"

PZRolePlayingRoles = PZRolePlayingRoles or {}

local Roles = PZRolePlayingRoles

Roles.MODULE = "PZRolePlaying"
Roles.MOD_DATA_ROLE_KEY = "PZRP_role"
Roles.MOD_DATA_LOCAL_APPLIED_KEY = "PZRP_localRoleApplied"
Roles.LEGACY_ROLE_KEY = "LR_role"
Roles.LEGACY_LOCAL_APPLIED_KEY = "LR_localRoleApplied"

Roles.ROLE_ORDER_VANILLA = PZRolePlayingRolesVanilla.ROLE_ORDER
Roles.ROLE_NAMES_VANILLA = PZRolePlayingRolesVanilla.ROLE_NAMES
Roles.ROLE_INFO_VANILLA = PZRolePlayingRolesVanilla.ROLE_INFO
Roles.ROLE_DEFS_VANILLA = PZRolePlayingRolesVanilla.ROLE_DEFS

Roles.ROLE_ORDER_BRITA = PZRolePlayingRolesBrita.ROLE_ORDER
Roles.ROLE_NAMES_BRITA = PZRolePlayingRolesBrita.ROLE_NAMES
Roles.ROLE_INFO_BRITA = PZRolePlayingRolesBrita.ROLE_INFO
Roles.ROLE_DEFS_BRITA = PZRolePlayingRolesBrita.ROLE_DEFS

local BRITA_PROBE_ITEMS = {
    "Base.PPK",
    "Base.M4A1",
    "Base.Suit_Wick",
}

function Roles.detectBritaInstalled()
    local sm = PZRolePlayingShared and PZRolePlayingShared.getScriptManagerInstance and PZRolePlayingShared.getScriptManagerInstance() or nil
    if sm == nil or sm.getItem == nil then return false end

    for _, itemId in ipairs(BRITA_PROBE_ITEMS) do
        local ok, item = pcall(function()
            return sm:getItem(itemId)
        end)
        if ok and item ~= nil then
            return true
        end
    end

    return false
end

function Roles.setBritaOverride(enabled)
    if enabled == nil then
        Roles._britaOverride = nil
        return
    end
    Roles._britaOverride = enabled == true
end

function Roles.clearBritaOverride()
    Roles._britaOverride = nil
end

function Roles.invalidateBritaCache()
    Roles._britaDetected = nil
end

function Roles.isBritaInstalled()
    if Roles._britaOverride ~= nil then
        return Roles._britaOverride == true
    end

    if Roles._britaDetected == nil then
        Roles._britaDetected = Roles.detectBritaInstalled() == true
    end

    return Roles._britaDetected == true
end

function Roles.getActiveRoleSet()
    if Roles.isBritaInstalled() then
        return {
            order = Roles.ROLE_ORDER_BRITA,
            names = Roles.ROLE_NAMES_BRITA,
            info = Roles.ROLE_INFO_BRITA,
            defs = Roles.ROLE_DEFS_BRITA,
        }
    end

    return {
        order = Roles.ROLE_ORDER_VANILLA,
        names = Roles.ROLE_NAMES_VANILLA,
        info = Roles.ROLE_INFO_VANILLA,
        defs = Roles.ROLE_DEFS_VANILLA,
    }
end

function Roles.getActiveRoleOrder()
    return Roles.getActiveRoleSet().order
end

function Roles.getActiveRoleNames()
    return Roles.getActiveRoleSet().names
end

function Roles.getActiveRoleInfo()
    return Roles.getActiveRoleSet().info
end

function Roles.getActiveRoleDefs()
    return Roles.getActiveRoleSet().defs
end

function Roles.getRoleName(roleKey)
    return Roles.getActiveRoleNames()[roleKey] or roleKey
end

function Roles.getRoleInfo(roleKey)
    return Roles.getActiveRoleInfo()[roleKey]
end

function Roles.normalizeModData(modData)
    if modData == nil then return nil end

    if modData[Roles.MOD_DATA_ROLE_KEY] == nil and modData[Roles.LEGACY_ROLE_KEY] ~= nil then
        modData[Roles.MOD_DATA_ROLE_KEY] = modData[Roles.LEGACY_ROLE_KEY]
    end

    if modData[Roles.MOD_DATA_LOCAL_APPLIED_KEY] == nil and modData[Roles.LEGACY_LOCAL_APPLIED_KEY] ~= nil then
        modData[Roles.MOD_DATA_LOCAL_APPLIED_KEY] = modData[Roles.LEGACY_LOCAL_APPLIED_KEY]
    end

    return modData
end

print("[PZRolePlaying] roles core charge")
