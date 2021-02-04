-- Move Blizzard's UIErrorsFrame
local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)

-- Blizz
local UIErrorsFrame = _G.UIErrorsFrame

-- ---------------

local isInit = false

local defaults = {
    width = 512,
    height = 60,
    text = {
        font = C.media.fonts.normal,
        size = 14,
        outline = false,
        shadow = false
    }
}

local function updateFont(fontString, config)
    fontString:SetFont(config.font or C.media.fonts.normal, config.size or 12,
                       config.outline and "THINOUTLINE" or nil)

    if config.shadow then
        fontString:SetShadowOffset(1, -1)
    else
        fontString:SetShadowOffset(0, 0)
    end
end

function M.HasErrorsFrame() return isInit end

function M.SetUpErrorsFrame()
    if not isInit and C.modules.blizzard.errors_frame.enabled then
        local frame = UIErrorsFrame
        local config = E:CopyTable(defaults, config)
        config = E:CopyTable(C.modules.blizzard.errors_frame, config)

        updateFont(frame, config.text)
        frame:SetSize(config.width, config.height)
        E:SetPosition(frame, config.point)

        isInit = true
    end
end
