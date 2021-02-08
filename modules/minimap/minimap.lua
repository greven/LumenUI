-- Credits: ls_UI
local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:AddModule("Minimap")

local isInit = false
local isSquare = false

-- Lua
local _G = getfenv(0)

local next = _G.next
local select = _G.select
local unpack = _G.unpack
local hooksecurefunc = _G.hooksecurefunc

local m_atan2 = _G.math.atan2
local m_cos = _G.math.cos
local m_deg = _G.math.deg
local m_floor = _G.math.floor
local m_max = _G.math.max
local m_min = _G.math.min
local m_rad = _G.math.rad
local m_sin = _G.math.sin
local s_match = _G.string.match
local t_insert = _G.table.insert
local t_sort = _G.table.sort
local t_wipe = _G.table.wipe

-- Blizz
local C_Calendar = _G.C_Calendar
local C_DateAndTime = _G.C_DateAndTime
local C_Garrison = _G.C_Garrison
local C_Timer = _G.C_Timer
local GetCursorPosition = _G.GetCursorPosition

local BLIZZ_BUTTONS = {
    ["MiniMapTracking"] = true,
    ["QueueStatusMinimapButton"] = true,
    ["MiniMapMailFrame"] = true,
    ["GameTimeFrame"] = true,
    ["GarrisonLandingPageMinimapButton"] = true
}

local PVP_COLOR_MAP = {
    ["arena"] = "hostile",
    ["combat"] = "hostile",
    ["contested"] = "contested",
    ["friendly"] = "friendly",
    ["hostile"] = "hostile",
    ["sanctuary"] = "sanctuary"
}

local buttonOrder = {
    ["GameTimeFrame"] = 1,
    ["GarrisonLandingPageMinimapButton"] = 2,
    ["MiniMapTrackingButton"] = 3,
    ["MiniMapMailFrame"] = 4,
    ["QueueStatusMinimapButton"] = 5
}

-- ---------------

local handledChildren = {}
local ignoredChildren = {}
local buttonData = {}
local collectedButtons = {}
local consolidatedButtons = {}
local hiddenButtons = {}
local watchedButtons = {}

local function hasTrackingBorderRegion(self)
    for i = 1, select("#", self:GetRegions()) do
        local region = select(i, self:GetRegions())

        if region:IsObjectType("Texture") then
            local texture = region:GetTexture()
            if texture and (texture == 136430 or
                s_match(texture,
                        "[tT][rR][aA][cC][kK][iI][nN][gG][bB][oO][rR][dD][eE][rR]")) then
                return true
            end
        end
    end

    return false
end

local function isMinimapButton(self)
    if BLIZZ_BUTTONS[self] then return true end

    if hasTrackingBorderRegion(self) then return true end

    for i = 1, select("#", self:GetChildren()) do
        if hasTrackingBorderRegion(select(i, self:GetChildren())) then
            return true
        end
    end

    return false
end

local function handleButton(button, isRecursive)
    if button == GarrisonLandingPageMinimapButton then return button end

    -- print("====|cff00ccff", button:GetDebugName(), "|r:====")
    local normal = button.GetNormalTexture and button:GetNormalTexture()
    local pushed = button.GetPushedTexture and button:GetPushedTexture()
    local hl, icon, border, bg, thl, ticon, tborder, tbg, tnormal, tpushed

    for i = 1, select("#", button:GetRegions()) do
        local region = select(i, button:GetRegions())
        if region:IsObjectType("Texture") then
            local name = region:GetDebugName()
            local texture = region:GetTexture()
            local layer = region:GetDrawLayer()
            -- print("|cffffff00", name, "|r:", texture, layer)

            if not normal then
                if layer == "ARTWORK" or layer == "BACKGROUND" then
                    if button.icon and region == button.icon then
                        -- print("|cffffff00", name, "|ris |cff00ff00.icon|r")
                        icon = region
                    elseif button.Icon and region == button.Icon then
                        -- print("|cffffff00", name, "|ris |cff00ff00.Icon|r")
                        icon = region
                        -- ignore all LDBIcons
                    elseif name and not s_match(name, "^LibDBIcon") and
                        s_match(name, "[iI][cC][oO][nN]") then
                        -- print("|cffffff00", name, "|ris |cff00ff00icon|r")
                        icon = region
                    elseif texture and s_match(texture, "[iI][cC][oO][nN]") then
                        -- print("|cffffff00", name, "|ris |cff00ff00-icon|r")
                        icon = region
                    elseif texture and texture == 136467 then
                        bg = region
                    elseif texture and
                        s_match(texture,
                                "[bB][aA][cC][kK][gG][rR][oO][uU][nN][dD]") then
                        -- print("|cffffff00", name, "|ris |cff00ff00-background|r")
                        bg = region
                    end
                end
            end

            if layer == "HIGHLIGHT" then
                -- print("|cffffff00", name, "|ris |cff00ff00HIGHLIGHT|r")
                hl = region
            else
                if button.border and button.border == region then
                    -- print("|cffffff00", name, "|ris |cff00ff00.border|r")
                    border = region
                elseif button.Border and button.Border == region then
                    -- print("|cffffff00", name, "|ris |cff00ff00.Border|r")
                    border = region
                elseif s_match(name, "[bB][oO][rR][dD][eE][rR]") then
                    -- print("|cffffff00", name, "|ris |cff00ff00border|r")
                    border = region
                elseif texture and (texture == 136430 or
                    s_match(texture,
                            "[tT][rR][aA][cC][kK][iI][nN][gG][bB][oO][rR][dD][eE][rR]")) then
                    -- print("|cffffff00", name, "|ris |cff00ff00-TrackingBorder|r")
                    border = region
                end
            end
        end
    end

    for i = 1, select("#", button:GetChildren()) do
        local child = select(i, button:GetChildren())
        local name = child:GetDebugName()
        local oType = child:GetObjectType()
        -- print("|cffffff00", name, "|r:", oType)

        if oType == "Frame" then
            if name and s_match(name, "[iI][cC][oO][nN]") then
                icon = child
            end
        elseif oType == "Button" then
            thl, ticon, tborder, tbg, tnormal, tpushed =
                handleButton(child, true)
            button.Button = child
            button.Button:SetAllPoints(button)
        end
    end

    normal = normal or tnormal
    pushed = pushed or tpushed
    hl = hl or thl
    icon = icon or ticon
    border = border or tborder
    bg = bg or tbg

    if isRecursive then
        return hl, icon, border, bg, normal, pushed
    else
        -- These aren't the dro- buttons you're looking for
        if not (icon or normal) then
            -- print("  |cffff2222", "BAILING OUT!", "|r")
            ignoredChildren[button] = true

            return button
        end

        -- local t = button == GameTimeFrame and "BIG" or "SMALL"
        local offset = 8

        button:SetSize(36, 36)
        button:SetHitRectInsets(0, 0, 0, 0)
        button:SetFlattensRenderLayers(true)

        local mask = button:CreateMaskTexture()
        mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall",
                        "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetPoint("TOPLEFT", 6, -6)
        mask:SetPoint("BOTTOMRIGHT", -6, 6)
        button.MaskTexture = mask

        if hl then
            hl:ClearAllPoints()
            hl:SetAllPoints(button)
            hl:AddMaskTexture(mask)
            button.HighlightTexture = hl
        end

        if pushed then
            pushed:SetDrawLayer("ARTWORK", 0)
            pushed:ClearAllPoints()
            pushed:SetPoint("TOPLEFT", offset, -offset)
            pushed:SetPoint("BOTTOMRIGHT", -offset, offset)
            pushed:AddMaskTexture(mask)
            button.PushedTexture = pushed
        end

        if normal then
            normal:SetDrawLayer("ARTWORK", 0)
            normal:ClearAllPoints()
            normal:SetPoint("TOPLEFT", offset, -offset)
            normal:SetPoint("BOTTOMRIGHT", -offset, offset)
            normal:AddMaskTexture(mask)
            button.NormalTexture = normal
        elseif icon then
            if icon:IsObjectType("Texture") then
                icon:SetDrawLayer("ARTWORK", 0)
                icon:ClearAllPoints()
                icon:SetPoint("TOPLEFT", offset, -offset)
                icon:SetPoint("BOTTOMRIGHT", -offset, offset)
                icon:AddMaskTexture(mask)
            else
                icon:SetFrameLevel(4)
                icon:ClearAllPoints()
                icon:SetPoint("TOPLEFT", offset, -offset)
                icon:SetPoint("BOTTOMRIGHT", -offset, offset)
            end

            button.Icon = icon
        end

        if not border then border = button:CreateTexture() end

        border:SetTexture(C.media.textures.border)
        border:SetTexCoord(90 / 256, 162 / 256, 1 / 256, 73 / 256)
        border:SetDrawLayer("ARTWORK", 1)
        border:SetAllPoints(button)
        button.Border = border

        if not bg then bg = button:CreateTexture() end

        bg:SetAlpha(1)
        bg:SetColorTexture(0, 0, 0, 0.6)
        bg:SetDrawLayer("BACKGROUND", 0)
        bg:SetAllPoints()
        bg:AddMaskTexture(mask)
        button.Background = bg

        return button
    end
end

local function sortFunc(a, b)
    local aName, bName = a:GetDebugName(), b:GetDebugName()
    if buttonOrder[aName] and buttonOrder[bName] then
        return buttonOrder[aName] < buttonOrder[bName]
    elseif buttonOrder[aName] and not buttonOrder[bName] then
        return true
    elseif not buttonOrder[aName] and buttonOrder[bName] then
        return false
    else
        return aName > bName
    end
end

local function consolidateButtons()
    t_wipe(consolidatedButtons)

    for collectedButton in next, collectedButtons do
        if not hiddenButtons[collectedButton] then
            t_insert(consolidatedButtons, collectedButton)
        end
    end

    if #consolidatedButtons > 0 then
        t_sort(consolidatedButtons, sortFunc)

        local maxRows = m_floor(#consolidatedButtons / 8 + 0.9)

        MinimapButtonCollection.Shadow:SetSize(64 + 64 * maxRows,
                                               64 + 64 * maxRows)

        for i, button in next, consolidatedButtons do
            local row = m_floor(i / 8 + 0.9)
            local angle = m_rad(90 - 45 * ((i - 1) % 8) + (30 * (row - 1))) -- 45 = 360 / 8

            button.AlphaIn:SetStartDelay(0.02 * (i - 1))
            button.AlphaOut:SetStartDelay(0.02 * (i - 1))

            button:ClearAllPoints_()
            button:SetPoint_("CENTER", MinimapButtonCollection, "CENTER",
                             m_cos(angle) * (16 + 32 * row),
                             m_sin(angle) * (16 + 32 * row))

            if not MinimapButtonCollection.isShown then
                button:Hide_()
            end
        end
    end
end

local function getPosition(scale, px, py)
    if not (px or py) then return 225 end

    local mx, my = Minimap:GetCenter()
    scale = scale or Minimap:GetEffectiveScale()

    return m_deg(m_atan2(py / scale - my, px / scale - mx)) % 360
end

local function hookHide(self)
    if collectedButtons[self] then
        hiddenButtons[self] = true

        consolidateButtons()
    end
end

local function hookShow(self)
    if collectedButtons[self] then
        hiddenButtons[self] = false

        consolidateButtons()
    end
end

local function hookSetShown(self, state)
    if collectedButtons[self] then
        hiddenButtons[self] = state

        consolidateButtons()
    end
end

local function collectButton(button)
    if collectedButtons[button] or button == MinimapButtonCollection then
        return
    end

    button:SetFrameLevel(Minimap:GetFrameLevel() + 4)

    buttonData[button] = {
        OnDragStart = button:GetScript("OnDragStart"),
        OnDragStop = button:GetScript("OnDragStop"),
        position = getPosition(1, button:GetCenter())
    }

    button:SetScript("OnDragStart", nil)
    button:SetScript("OnDragStop", nil)
    button:RegisterForDrag(false)

    -- some addon devs use strong voodoo to implement dragging/moving
    button.ClearAllPoints_ = button.ClearAllPoints
    button.SetPoint_ = button.SetPoint

    if not button:GetAttribute("ls-hooked") then
        button.Hide_ = button.Hide
        button.Show_ = button.Show

        hooksecurefunc(button, "Hide", hookHide)
        hooksecurefunc(button, "Show", hookShow)
        hooksecurefunc(button, "SetShown", hookSetShown)

        button:SetAttribute("ls-hooked", true)
    end

    hiddenButtons[button] = not button:IsShown()

    if not BLIZZ_BUTTONS[button:GetName()] then
        button.ClearAllPoints = nop
        button.SetPoint = nop
    end

    if not button.AlphaIn then
        local anim = MinimapButtonCollection.AGIn:CreateAnimation("Alpha")
        anim:SetOrder(2)
        anim:SetTarget(button)
        anim:SetFromAlpha(0)
        anim:SetToAlpha(1)
        anim:SetDuration(0.08)
        button.AlphaIn = anim
    else
        button.AlphaIn:SetParent(MinimapButtonCollection.AGIn)
        button.AlphaIn:SetOrder(2)
    end

    if not button.AlphaOut then
        local anim = MinimapButtonCollection.AGOut:CreateAnimation("Alpha")
        anim:SetOrder(1)
        anim:SetTarget(button)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)
        anim:SetDuration(0.08)
        button.AlphaOut = anim
    else
        button.AlphaOut:SetParent(MinimapButtonCollection.AGOut)
        button.AlphaOut:SetOrder(1)
    end

    collectedButtons[button] = true

    consolidateButtons()
end

local function releaseButton(button)
    if not collectedButtons[button] or button == MinimapButtonCollection then
        return
    end

    button:SetAlpha(1)
    button:SetFrameLevel(Minimap:GetFrameLevel() + 2)

    if buttonData[button].OnDragStart then
        button:SetScript("OnDragStart", buttonData[button].OnDragStart)
        button:SetScript("OnDragStop", buttonData[button].OnDragStop)
        button:RegisterForDrag("LeftButton")
    end

    if button.ClearAllPoints == nop then
        button.ClearAllPoints = button.ClearAllPoints_
        button.SetPoint = button.SetPoint_
    end

    button.AlphaIn:SetParent(MinimapButtonCollection.AGDisabled)
    button.AlphaOut:SetParent(MinimapButtonCollection.AGDisabled)

    if not hiddenButtons[button] then button:Show_() end

    button.ClearAllPoints_ = nil
    button.SetPoint_ = nil

    collectedButtons[button] = nil

    consolidateButtons()
end

local function updatePosition(button, degrees)
    local angle = m_rad(degrees)
    local w = Minimap:GetWidth() / 2 + 5
    local h = Minimap:GetHeight() / 2 + 5

    if isSquare then
        button:SetPoint("CENTER", Minimap, "CENTER", m_max(-w, m_min(
                                                               m_cos(angle) *
                                                                   (1.4142135623731 *
                                                                       w - 10),
                                                               w)), m_max(-h,
                                                                          m_min(
                                                                              m_sin(
                                                                                  angle) *
                                                                                  (1.4142135623731 *
                                                                                      h -
                                                                                      10),
                                                                              h)))
    else
        button:SetPoint("CENTER", Minimap, "CENTER", m_cos(angle) * w,
                        m_sin(angle) * h)
    end
end

local function button_OnUpdate(self)
    local degrees = getPosition(nil, GetCursorPosition())

    C.modules.minimap.buttons[self:GetName()] = degrees

    updatePosition(self, degrees)
end

local function button_OnDragStart(self)
    self.OnUpdate = self:GetScript("OnUpdate")
    self:SetScript("OnUpdate", button_OnUpdate)
end

local function button_OnDragStop(self)
    self:SetScript("OnUpdate", self.OnUpdate)
    self.OnUpdate = nil
end

local function getTooltipPoint(self)
    local quadrant = E:GetScreenQuadrant(self)
    local p, rP, x, y = "TOPLEFT", "BOTTOMRIGHT", -4, 4

    if quadrant == "BOTTOMLEFT" or quadrant == "BOTTOM" then
        p, rP, x, y = "BOTTOMLEFT", "TOPRIGHT", -4, -4
    elseif quadrant == "TOPRIGHT" or quadrant == "RIGHT" then
        p, rP, x, y = "TOPRIGHT", "BOTTOMLEFT", 4, 4
    elseif quadrant == "BOTTOMRIGHT" then
        p, rP, x, y = "BOTTOMRIGHT", "TOPLEFT", 4, -4
    end

    return p, rP, x, y
end

local function minimap_UpdateConfig(self)
    self._config = E:CopyTable(C.modules.minimap, self._config)
    self._config.buttons = E:CopyTable(C.modules.minimap.buttons,
                                       self._config.buttons)
    self._config.collect = E:CopyTable(C.modules.minimap.collect,
                                       self._config.collect)
    self._config.color =
        E:CopyTable(C.modules.minimap.color, self._config.color)
    self._config.size = C.modules.minimap.size
end

local function minimap_UpdateSize(self)
    local config = self._config
    Minimap:SetSize(config.size, config.size)
    LumMinimapHolder:SetSize(config.size, config.size + 20)
end

local function minimap_UpdateButtons(self)
    local config = self._config

    if config.collect.enabled then
        MinimapButtonCollection:Show()
        updatePosition(MinimapButtonCollection,
                       config.buttons["MinimapButtonCollection"])
    else
        MinimapButtonCollection.isShown = false
        MinimapButtonCollection:Hide()
        MinimapButtonCollection.Shadow:SetScale(0.001)
    end

    if config.collect.enabled and config.collect.calendar then
        collectButton(GameTimeFrame)
    else
        releaseButton(GameTimeFrame)
        updatePosition(GameTimeFrame, config.buttons["GameTimeFrame"])
    end

    if config.collect.enabled and config.collect.garrison then
        collectButton(GarrisonLandingPageMinimapButton)
    else
        releaseButton(GarrisonLandingPageMinimapButton)
        updatePosition(GarrisonLandingPageMinimapButton,
                       config.buttons["GarrisonLandingPageMinimapButton"])
    end

    if config.collect.enabled and config.collect.mail then
        collectButton(MiniMapMailFrame)
    else
        releaseButton(MiniMapMailFrame)
        updatePosition(MiniMapMailFrame, config.buttons["MiniMapMailFrame"])
    end

    if config.collect.enabled and config.collect.queue then
        collectButton(QueueStatusMinimapButton)
    else
        releaseButton(QueueStatusMinimapButton)
        updatePosition(QueueStatusMinimapButton,
                       config.buttons["QueueStatusMinimapButton"])
    end

    if config.collect.enabled and config.collect.tracking then
        collectButton(MiniMapTrackingButton)
    else
        releaseButton(MiniMapTrackingButton)
        updatePosition(MiniMapTrackingButton,
                       config.buttons["MiniMapTrackingButton"])
    end

    if config.collect.enabled then
        for button in next, watchedButtons do
            if not collectedButtons[button] then
                collectButton(button)
            end
        end
    else
        for button in next, watchedButtons do
            if collectedButtons[button] then
                releaseButton(button)
                updatePosition(button, buttonData[button].position)
            end
        end
    end
end

function M:IsInit() return isInit end

function M:Init()
    if not isInit and C.modules.bars.enabled then
        if not IsAddOnLoaded("Blizzard_TimeManager") then
            LoadAddOn("Blizzard_TimeManager")
        end

        isSquare = C.modules.minimap.square

        -- local level = Minimap:GetFrameLevel()
        -- local holder = CreateFrame("Frame", "LumMinimapHolder", UIParent)
        -- holder:SetSize(1, 1)
        -- holder:SetPoint(unpack(config.point))

        -- Minimap:EnableMouseWheel()
        -- Minimap:ClearAllPoints()
        -- Minimap:SetParent(holder)

        -- Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
        -- Minimap:SetPoint("BOTTOM", 0, 0)

        -- Minimap:RegisterEvent("ZONE_CHANGED")
        -- Minimap:RegisterEvent("ZONE_CHANGED_INDOORS")
        -- Minimap:RegisterEvent("ZONE_CHANGED_NEW_AREA")

        -- Minimap:HookScript("OnEvent", function(self, event)
        --     if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or
        --         event == "ZONE_CHANGED_NEW_AREA" then
        --         -- print(event)
        --     end
        -- end)

        -- RegisterStateDriver(Minimap, "visibility", "[petbattle] hide; show")

        -- local textureParent = CreateFrame("Frame", nil, Minimap)
        -- textureParent:SetFrameLevel(level + 1)
        -- textureParent:SetPoint("BOTTOMRIGHT", 0, 0)
        -- Minimap.TextureParent = textureParent

        -- if isSquare then
        --     Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
        --     Minimap:SetPoint("BOTTOM", 0, 0)

        --     textureParent:SetPoint("TOPLEFT", 0, 0)

        --     local border = E:CreateBorder(textureParent)
        --     border:SetTexture(C.media.textures.border_thick)
        --     border:SetVertexColor(E:GetRGB(C.global.border.color))
        --     border:SetOffset(-5)
        --     Minimap.Border = border

        --     local bg = E:SetBackdrop(textureParent, E.SCREEN_SCALE * 3)
        --     bg:SetFrameLevel(level - 1)
        --     E:CreateShadow(textureParent)
        -- else
        --     Minimap:SetMaskTexture(
        --         "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
        --     Minimap:SetPoint("BOTTOM", 0, 10)

        --     textureParent:SetPoint("TOPLEFT", 0, 0)
        -- end

        -- -- .Collection
        -- do
        --     local button = CreateFrame("Button", "MinimapButtonCollection",
        --                                Minimap)
        --     button:SetFrameLevel(level + 3)
        --     button:RegisterForDrag("LeftButton")
        --     button:SetHighlightTexture(
        --         "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        --     button:SetScript("OnDragStart", button_OnDragStart)
        --     button:SetScript("OnDragStop", button_OnDragStop)
        --     Minimap.Collection = button

        --     button:SetScript("OnEnter", function(self)
        --         if C.modules.minimap.collect.tooltip then
        --             local p, rP, x, y = getTooltipPoint(self)

        --             GameTooltip:SetOwner(self, "ANCHOR_NONE")
        --             GameTooltip:SetPoint(p, self, rP, x, y)
        --             GameTooltip:AddLine(L["MINIMAP_BUTTONS"], 1, 1, 1)
        --             GameTooltip:AddLine(L["MINIMAP_BUTTONS_TOOLTIP"])
        --             GameTooltip:Show()
        --         end
        --     end)
        --     button:SetScript("OnLeave", function() GameTooltip:Hide() end)

        --     local border = button:CreateTexture(nil, "OVERLAY")
        --     border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

        --     local background = button:CreateTexture(nil, "BACKGROUND")
        --     background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

        --     local icon = button:CreateTexture(nil, "ARTWORK")
        --     icon:SetTexture("Interface\\LFGFRAME\\WaitAnim")
        --     icon:SetTexCoord(64 / 128, 128 / 128, 64 / 128, 128 / 128)
        --     button.Icon = icon

        --     handleButton(button)

        --     local shadow = button:CreateTexture(nil, "BACKGROUND")
        --     shadow:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
        --     shadow:SetVertexColor(0, 0, 0)
        --     shadow:SetPoint("CENTER")
        --     shadow:SetAlpha(0.6)
        --     shadow:SetScale(0.001)
        --     button.Shadow = shadow

        --     local agIn = button:CreateAnimationGroup()
        --     button.AGIn = agIn

        --     agIn:SetScript("OnPlay", function()
        --         shadow:SetScale(1)

        --         for i = 1, #consolidatedButtons do
        --             consolidatedButtons[i]:SetAlpha(0)
        --             consolidatedButtons[i]:Show_()
        --         end
        --     end)
        --     agIn:SetScript("OnStop", function()
        --         shadow:SetScale(1)

        --         for i = 1, #consolidatedButtons do
        --             consolidatedButtons[i]:SetAlpha(1)
        --         end
        --     end)
        --     agIn:SetScript("OnFinished", function()
        --         shadow:SetScale(1)

        --         for i = 1, #consolidatedButtons do
        --             consolidatedButtons[i]:SetAlpha(1)
        --         end
        --     end)

        --     local agOut = button:CreateAnimationGroup()
        --     button.AGOut = agOut

        --     agOut:SetScript("OnPlay", function()
        --         shadow:SetScale(1)

        --         for i = 1, #consolidatedButtons do
        --             consolidatedButtons[i]:SetAlpha(1)
        --         end
        --     end)
        --     agOut:SetScript("OnStop", function()
        --         shadow:SetScale(0.001)

        --         for i = 1, #consolidatedButtons do
        --             consolidatedButtons[i]:SetAlpha(0)
        --             consolidatedButtons[i]:Hide_()
        --         end
        --     end)
        --     agOut:SetScript("OnFinished", function()
        --         shadow:SetScale(0.001)

        --         for i = 1, #consolidatedButtons do
        --             consolidatedButtons[i]:SetAlpha(0)
        --             consolidatedButtons[i]:Hide_()
        --         end
        --     end)

        --     local anim = agIn:CreateAnimation("Scale")
        --     anim:SetTarget(shadow)
        --     anim:SetOrder(1)
        --     anim:SetFromScale(0.001, 0.001)
        --     anim:SetToScale(1, 1)
        --     anim:SetDuration(0.08)
        --     button.ScaleIn = anim

        --     anim = agOut:CreateAnimation("Scale")
        --     anim:SetTarget(shadow)
        --     anim:SetOrder(2)
        --     anim:SetToScale(0.001, 0.001)
        --     anim:SetFromScale(1, 1)
        --     anim:SetDuration(0.08)
        --     button.ScaleOut = anim

        --     button.AGDisabled = button:CreateAnimationGroup()

        --     button:SetScript("OnClick", function(self)
        --         if not self.isShown then
        --             agOut:Stop()
        --             agIn:Play()

        --             self.isShown = true
        --         else
        --             agIn:Stop()
        --             agOut:Play()

        --             self.isShown = false
        --         end
        --     end)

        --     ignoredChildren[button] = true
        -- end

        -- local function handleChildren()
        --     local shouldCollect = C.modules.minimap.collect.enabled

        --     for i = 1, select("#", Minimap:GetChildren()) do
        --         local child = select(i, Minimap:GetChildren())
        --         if not ignoredChildren[child] then
        --             child:SetFrameLevel(level + 2)

        --             if not handledChildren[child] and isMinimapButton(child) then
        --                 handleButton(child)

        --                 watchedButtons[child] = true

        --                 if shouldCollect then
        --                     collectButton(child)
        --                 end
        --             end

        --             ignoredChildren[child] = true
        --         end
        --     end
        -- end

        -- handleChildren()

        Minimap.UpdateConfig = minimap_UpdateConfig
        -- Minimap.UpdateSize = minimap_UpdateSize
        -- Minimap.UpdateButtons = minimap_UpdateButtons

        isInit = true

        self:Update()
    end
end

function M:Update()
    if isInit then
        Minimap:UpdateConfig()
        -- Minimap:UpdateSize()
        -- Minimap:UpdateButtons()
    end
end
