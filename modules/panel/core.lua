local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:AddModule("Panel")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false

local function frame_UpdateConfig(self)
    self._config = E:CopyTable(C.modules.panel, self._config)
end

local function frame_UpdateSize(self)
    self:SetSize(self._config.width, self._config.height)
end

local function frame_UpdatePoints(self) E:SetPosition(self, self._config.point) end

function M:IsInit() return isInit end

function M:Init()
    if not isInit and C.modules.panel.enabled then
        local frame = CreateFrame("Frame", "LumPanel", _G.UIParent)
        frame:SetFrameLevel(5)
        local bg = E:SetBackdrop(frame, 2, 0.95, nil, {
            bgFile = C.media.textures.vertlines,
            tile = true,
            tileSize = 8
        })
        bg:SetBackdropColor(E:GetRGBA(C.global.backdrop.color))

        frame.UpdateConfig = frame_UpdateConfig
        frame.UpdateSize = frame_UpdateSize
        frame.UpdatePoints = frame_UpdatePoints

        isInit = true

        self:Update(frame)
    end
end

function M:Update(frame)
    if isInit then
        frame:UpdateConfig()
        frame:UpdateSize()
        frame:UpdatePoints()
    end
end
