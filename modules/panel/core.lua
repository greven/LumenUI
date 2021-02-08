local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:AddModule("Panel")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false
local Panel = CreateFrame("Frame", "LumPanel", _G.UIParent)

local function panel_UpdateConfig(self)
    self._config = E:CopyTable(C.modules.panel, self._config)
end

local function panel_UpdateSize(self)
    self:SetSize(self._config.width, self._config.height)
end

local function panel_UpdatePoints(self) E:SetPosition(self, self._config.point) end

function M:IsInit() return isInit end

function M:Init()
    if not isInit and C.modules.panel.enabled then
        Panel:SetFrameLevel(5)

        local bg = E:SetBackdrop(Panel, E.SCREEN_SCALE * 3, 0.95, nil, {
            bgFile = C.media.textures.vertlines,
            tile = true,
            tileSize = 8
        })
        bg:SetBackdropColor(E:GetRGBA(C.global.backdrop.color))

        Panel.UpdateConfig = panel_UpdateConfig
        Panel.UpdateSize = panel_UpdateSize
        Panel.UpdatePoints = panel_UpdatePoints

        isInit = true

        self:Update()
    end
end

function M:Update()
    if isInit then
        Panel:UpdateConfig()
        Panel:UpdateSize()
        Panel:UpdatePoints()

        if Panel._config.visibility then
            RegisterAttributeDriver(Panel, "state-visibility",
                                    Panel._config.visibility)
        end
    end
end
