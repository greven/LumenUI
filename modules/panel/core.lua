local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L

local PANEL = E:AddModule("Panel")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false
local elements = {}
local Panel

local function panel_UpdateConfig(self)
    self._config = E:CopyTable(C.db.profile.modules.panel, self._config)
end

local function panel_UpdateSize(self)
    self:SetSize(self._config.width, self._config.height)
end

local function panel_UpdateBackdrop(self)
    local bg =
        E:SetBackdrop(
        self,
        E.SCREEN_SCALE * 3,
        0.95,
        nil,
        {
            bgFile = M.textures.vertlines,
            tile = true,
            tileSize = 8
        }
    )
    bg:SetBackdropColor(E:GetRGBA(C.db.global.backdrop.color))
end

local function panel_UpdatePoints(self)
    E:SetPosition(self, self._config.point)
end

local function element_UpdateVisibility(self)
    -- element_UpdateVisibility
end

local function element_UpdateConfig(self)
    self._config = E:CopyTable(C.db.profile.modules.panel[self._id], self._config)
end

local function element_UpdatePoints(self)
    local config = self._config

    self:ClearAllPoints()

    local point = config.point
    if point and point.p then
        self:SetPoint(point.p, E:ResolveAnchorPoint(self.__owner, point.anchor), point.ap, point.x, point.y)
    end
end

function PANEL.GetElements()
    return elements
end

function PANEL.GetElement(_, elementID)
    return elements[elementID]
end

function PANEL.AddElement(_, elementID, element)
    elements[elementID] = element
    element.UpdateConfig = element_UpdateConfig
    element.UpdatePoints = element_UpdatePoints
    element.UpdateVisibility = element_UpdateVisibility
end

function PANEL:IsInit()
    return isInit
end

function PANEL:Init()
    if not isInit and C.db.profile.modules.panel.enabled then
        Panel = CreateFrame("Frame", "LumPanel", _G.UIParent)

        Panel.UpdateConfig = panel_UpdateConfig
        Panel.UpdateSize = panel_UpdateSize
        Panel.UpdatePoints = panel_UpdatePoints
        Panel.UpdateBackdrop = panel_UpdateBackdrop

        local textParent = CreateFrame("Frame", nil, Panel)
        textParent:SetAllPoints()
        textParent:SetFrameLevel(Panel:GetFrameLevel() + 10)

        -- PANEL:CreateXPTOelement()
        -- NOTE: Just a test! E:CreateString(frame, size, color, font, name, anchor, x, y)
        Panel.TestText = E:CreateString(textParent, 10)
        Panel.TestText:SetPoint("CENTER", textParent, 0, 0)
        Panel.TestText:SetText("HELLO WORLD!")

        isInit = true

        self:Update()
    end
end

function PANEL:Update()
    if isInit then
        Panel:UpdateConfig()
        Panel:UpdateSize()
        Panel:UpdatePoints()
        Panel:UpdateBackdrop()

        if Panel._config.visibility then
            RegisterAttributeDriver(Panel, "state-visibility", Panel._config.visibility)
        end
    end
end
