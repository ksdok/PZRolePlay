require "ISUI/ISPanel"
require "ISUI/ISButton"
require "PZRolePlayingRoles"

PZRolePlayingRolePicker = PZRolePlayingRolePicker or {}

local MODULE = PZRolePlayingRoles.MODULE or "PZRolePlaying"
local DEBUG_ENABLED = true

local function logRolePicker(message)
    if not DEBUG_ENABLED then return end
    print("[PZRolePlaying][RolePicker] " .. tostring(message))
end

local RolePickerPanel = ISPanel:derive("PZRolePlayingRolePickerPanel")

local COLOR_BG = {r = 0.05, g = 0.05, b = 0.05, a = 0.92}
local COLOR_BORDER = {r = 0.7, g = 0.7, b = 0.7, a = 1}
local COLOR_ROW = {r = 0.14, g = 0.14, b = 0.14, a = 0.85}
local COLOR_AVAILABLE = {r = 0.2, g = 0.85, b = 0.3, a = 1}
local COLOR_PENDING = {r = 1, g = 0.85, b = 0.2, a = 1}
local COLOR_WHITE = {r = 1, g = 1, b = 1, a = 1}
local COLOR_RED = {r = 0.9, g = 0.35, b = 0.35, a = 1}

-- ── Layout de la grille (adaptatif au nombre de rôles) ──
local ROW_TOP = 92
local ROW_HEIGHT = 74
local CARD_HEIGHT = 68
local COLUMN_GAP = 16
local CARD_WIDTH_TARGET = 250

local function computeGridLayout(roleCount)
    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()
    -- Hauteur de contenu disponible (sous le header, avec marges)
    local availHeight = math.max(240, screenH - 20 - ROW_TOP - 40)
    local maxRows = math.max(3, math.floor(availHeight / ROW_HEIGHT))
    -- On grandit en hauteur d'abord : nombre minimal de colonnes pour tenir
    local columns = math.max(3, math.ceil(roleCount / maxRows))
    local rowsPerColumn = math.max(1, math.ceil(roleCount / columns))
    local neededWidth = 32 + columns * CARD_WIDTH_TARGET + (columns - 1) * COLUMN_GAP
    local neededHeight = ROW_TOP + rowsPerColumn * ROW_HEIGHT + 40
    return columns, rowsPerColumn, neededWidth, neededHeight
end

PZRolePlayingRolePicker.panel = nil
PZRolePlayingRolePicker.pendingRole = nil
PZRolePlayingRolePicker.statusText = nil
PZRolePlayingRolePicker.statusColor = COLOR_WHITE
PZRolePlayingRolePicker.mode = "network"

local function getRoleOrder()
    return PZRolePlayingRoles.getActiveRoleOrder() or {}
end

local function getRoleInfo()
    return PZRolePlayingRoles.getActiveRoleInfo() or {}
end

local function setButtonEnabled(button, enabled)
    if button == nil then return end
    if button.setEnable ~= nil then
        button:setEnable(enabled)
    else
        button.enable = enabled
    end
end

local function setButtonTitle(button, title)
    if button == nil then return end
    if button.setTitle ~= nil then
        button:setTitle(title)
    else
        button.title = title
    end
end

function RolePickerPanel:initialise()
    ISPanel.initialise(self)
end

function RolePickerPanel:createChildren()
    ISPanel.createChildren(self)

    self.roleButtons = {}
    self.cardLayouts = {}
    self.rowTop = ROW_TOP
    self.rowHeight = ROW_HEIGHT
    self.cardHeight = CARD_HEIGHT
    self.columnGap = COLUMN_GAP
    self.buttonWidth = 118
    self.buttonHeight = 24

    local roleOrder = getRoleOrder()
    local roleCount = #roleOrder
    self.columns, self.rowsPerColumn = computeGridLayout(roleCount)

    local contentWidth = self.width - 32
    self.cardWidth = math.floor((contentWidth - (self.columns - 1) * self.columnGap) / self.columns)

    for index, roleKey in ipairs(roleOrder) do
        local column = math.floor((index - 1) / self.rowsPerColumn)
        local row = (index - 1) % self.rowsPerColumn
        local x = 16 + (column * (self.cardWidth + self.columnGap))
        local y = self.rowTop + (row * self.rowHeight)

        self.cardLayouts[roleKey] = {
            x = x,
            y = y,
            width = self.cardWidth,
            height = self.cardHeight,
        }

        local buttonX = x + self.cardWidth - self.buttonWidth - 10
        local buttonY = y + self.cardHeight - self.buttonHeight - 8
        local button = ISButton:new(buttonX, buttonY, self.buttonWidth, self.buttonHeight, "Choisir", self, RolePickerPanel.onChooseRole)
        button.internal = roleKey
        button:initialise()
        button:instantiate()
        self:addChild(button)
        self.roleButtons[roleKey] = button
    end

    self:updateButtons()
end

function RolePickerPanel:onChooseRole(button)
    local roleKey = button and button.internal or nil
    if roleKey == nil then return end

    PZRolePlayingRolePicker.setPending(roleKey)

    if PZRolePlayingRolePicker.mode == "solo" then
        if PZRolePlayingClient ~= nil and PZRolePlayingClient.chooseRoleLocal ~= nil then
            PZRolePlayingClient.chooseRoleLocal(roleKey)
        else
            PZRolePlayingRolePicker.setStatus("Client solo indisponible.", COLOR_RED)
        end
        return
    end

    logRolePicker("Choix reseau demande: " .. tostring(roleKey))
    sendClientCommand(MODULE, "ChooseRole", {
        roleKey = roleKey,
    })
end

function RolePickerPanel:updateButtons()
    local roleOrder = getRoleOrder()
    for _, roleKey in ipairs(roleOrder) do
        local button = self.roleButtons[roleKey]
        local enabled = PZRolePlayingRolePicker.pendingRole == nil
        local title = "Choisir"

        if PZRolePlayingRolePicker.pendingRole == roleKey then
            enabled = false
            title = "Validation..."
        elseif PZRolePlayingRolePicker.pendingRole ~= nil then
            enabled = false
        end

        setButtonTitle(button, title)
        setButtonEnabled(button, enabled)
    end
end

function RolePickerPanel:prerender()
    ISPanel.prerender(self)

    local roleCount = #getRoleOrder()
    local setLabel = PZRolePlayingRoles.isBritaInstalled() and "Brita" or "Vanilla"

    self:drawTextCentre("Choisis ton role", self.width / 2, 12, 1, 1, 1, 1, UIFont.Medium)
    self:drawText(string.format("%d roles. Les doublons sont autorises et le choix est definitif pour la partie.", roleCount), 16, 40, 0.9, 0.9, 0.9, 1, UIFont.Small)
    self:drawText("Set actif: " .. tostring(setLabel) .. " (detection runtime)", 16, 58, 0.9, 0.9, 0.9, 1, UIFont.Small)
end

function RolePickerPanel:render()
    ISPanel.render(self)

    local roleOrder = getRoleOrder()
    local roleInfo = getRoleInfo()

    for _, roleKey in ipairs(roleOrder) do
        local info = roleInfo[roleKey]
        local layout = self.cardLayouts[roleKey]
        if info ~= nil and layout ~= nil then
            local rowX = layout.x
            local rowY = layout.y
            local rowWidth = layout.width
            local rowHeight = layout.height

            self:drawRect(rowX, rowY, rowWidth, rowHeight, COLOR_ROW.a, COLOR_ROW.r, COLOR_ROW.g, COLOR_ROW.b)
            self:drawRectBorder(rowX, rowY, rowWidth, rowHeight, 0.8, 0.35, 0.35, 0.35)

            self:drawText(info.name, rowX + 10, rowY + 8, 1, 1, 1, 1, UIFont.Medium)
            self:drawText(info.summary, rowX + 10, rowY + 28, 0.86, 0.86, 0.86, 1, UIFont.Small)
            self:drawText(info.strengths, rowX + 10, rowY + 44, 0.72, 0.72, 0.72, 1, UIFont.Small)

            -- Statut : on n'affiche plus « Disponible » (clutter). On ne montre
            -- le statut que si un choix est en cours de validation pour ce rôle.
            if PZRolePlayingRolePicker.pendingRole == roleKey then
                self:drawText("Validation en cours...", rowX + 10, rowY + 58, COLOR_PENDING.r, COLOR_PENDING.g, COLOR_PENDING.b, COLOR_PENDING.a, UIFont.Small)
            end
        end
    end

    if PZRolePlayingRolePicker.statusText ~= nil then
        local c = PZRolePlayingRolePicker.statusColor or COLOR_WHITE
        self:drawTextCentre(PZRolePlayingRolePicker.statusText, self.width / 2, self.height - 24, c.r, c.g, c.b, c.a, UIFont.Small)
    end
end

function PZRolePlayingRolePicker.isVisible()
    return PZRolePlayingRolePicker.panel ~= nil
end

function PZRolePlayingRolePicker.setStatus(text, color)
    PZRolePlayingRolePicker.statusText = text
    PZRolePlayingRolePicker.statusColor = color or COLOR_WHITE
    if PZRolePlayingRolePicker.panel ~= nil then
        PZRolePlayingRolePicker.panel:updateButtons()
    end
end

function PZRolePlayingRolePicker.setPending(roleKey)
    PZRolePlayingRolePicker.pendingRole = roleKey
    PZRolePlayingRolePicker.statusText = "Validation du role en cours..."
    PZRolePlayingRolePicker.statusColor = COLOR_PENDING
    if PZRolePlayingRolePicker.panel ~= nil then
        PZRolePlayingRolePicker.panel:updateButtons()
    end
end

function PZRolePlayingRolePicker.open(mode)
    PZRolePlayingRolePicker.mode = mode or "network"
    PZRolePlayingRolePicker.pendingRole = nil
    PZRolePlayingRolePicker.statusText = nil
    PZRolePlayingRolePicker.statusColor = COLOR_WHITE

    logRolePicker("Ouverture du picker (mode=" .. tostring(PZRolePlayingRolePicker.mode) .. ")")

    if PZRolePlayingRolePicker.panel ~= nil then
        PZRolePlayingRolePicker.panel:removeFromUIManager()
        PZRolePlayingRolePicker.panel = nil
    end

    local roleCount = #(PZRolePlayingRoles.getActiveRoleOrder() or {})
    local columns, rowsPerColumn, neededWidth, neededHeight = computeGridLayout(roleCount)
    local width = math.min(neededWidth, getCore():getScreenWidth() - 20)
    local height = math.min(math.max(neededHeight, 360), getCore():getScreenHeight() - 20)
    local x = math.max(10, math.floor((getCore():getScreenWidth() - width) / 2))
    local y = math.max(10, math.floor((getCore():getScreenHeight() - height) / 2))

    local panel = RolePickerPanel:new(x, y, width, height)
    panel:initialise()
    panel:instantiate()
    panel.backgroundColor = COLOR_BG
    panel.borderColor = COLOR_BORDER
    panel.moveWithMouse = false
    panel:createChildren()
    panel:addToUIManager()

    PZRolePlayingRolePicker.panel = panel
    return panel
end

function PZRolePlayingRolePicker.openLocal()
    return PZRolePlayingRolePicker.open("solo")
end

function PZRolePlayingRolePicker.close()
    logRolePicker("Fermeture du picker")
    PZRolePlayingRolePicker.pendingRole = nil
    PZRolePlayingRolePicker.statusText = nil
    if PZRolePlayingRolePicker.panel ~= nil then
        PZRolePlayingRolePicker.panel:removeFromUIManager()
        PZRolePlayingRolePicker.panel = nil
    end
end
