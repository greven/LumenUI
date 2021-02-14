local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local BARS = P:GetModule("Bars")

-- Lua
local _G = getfenv(0)

-- Blizzard
local CreateFrame = _G.CreateFrame
local UnitName = _G.UnitName
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local UnitExists = _G.UnitExists
local UnitAffectingCombat = _G.UnitAffectingCombat
local UnitDetailedThreatSituation = _G.UnitDetailedThreatSituation
local GetThreatStatusColor = _G.GetThreatStatusColor
local UnitReaction = _G.UnitReaction
local UnitIsPlayer = _G.UnitIsPlayer
local UnitClass = _G.UnitClass
local UNKNOWN = _G.UNKNOWN

-- ---------------

local isInit = false

local function element_GetLargestThreatOnList(self, percent)
  local largestValue, largestUnit = 0, nil
  for unit, threatPercent in pairs(self.list) do
    if threatPercent > largestValue then
      largestValue = threatPercent
      largestUnit = unit
    end
  end

  return (percent - largestValue), largestUnit
end

local function element_OnEvent(self, event, ...)
  local bar = self.Bar
  local isInGroup, isInRaid, petExists = IsInGroup(), IsInRaid(), UnitExists("pet")

  if UnitAffectingCombat("player") and (isInGroup or petExists) then
    local _, status, percent = UnitDetailedThreatSituation("player", "target")
    local name = UnitName("target") or UNKNOWN

    bar:Show()

    if percent == 100 then
      if petExists then
        self.list.pet = select(3, UnitDetailedThreatSituation("pet", "target"))
      end

      if isInRaid then
        for i = 1, 40 do
          if UnitExists("raid" .. i) and not UnitIsUnit("raid" .. i, "player") then
            self.list["raid" .. i] = select(3, UnitDetailedThreatSituation("raid" .. i, "target"))
          end
        end
      elseif isInGroup then
        for i = 1, 4 do
          if UnitExists("party" .. i) then
            self.list["party" .. i] = select(3, UnitDetailedThreatSituation("party" .. i, "target"))
          end
        end
      end

      local leadPercent, largestUnit = self:GetLargestThreatOnList(percent)
      if leadPercent > 0 and largestUnit ~= nil then
        local r, g, b = E:GetUnitColor(largestUnit, true, true)

        if E.PLAYER_GROUP_ROLE then
          bar:SetStatusBarColor(0, 0.839, 0)
          bar:SetValue(leadPercent)
        else
          bar:SetStatusBarColor(GetThreatStatusColor(status))
          bar:SetValue(percent)
        end
      else
        bar:SetStatusBarColor(GetThreatStatusColor(status))
        -- bar.Text:SetFormattedText("%s: %.0f%%", name, percent)
        bar:SetValue(percent)
      end
    elseif percent then
      bar:SetStatusBarColor(C.db.global.colors.threat[status])
      -- bar.Text:SetFormattedText("%s: %.0f%%", name, percent)
      bar:SetValue(percent)
    else
      bar:Hide()
    end
  else
    bar:Hide()
  end
end

local function element_UpdatePoints(self)
  E:SetPosition(self, self._config.point)
end

local function element_Update(self)
  self:UpdateConfig()

  if self._config.enabled then
    self:UpdatePoints()
    self:UpdateSize()
  else
    self:UnregisterEvent("PLAYER_TARGET_CHANGED")
    self:UnregisterEvent("UNIT_THREAT_LIST_UPDATE")
    self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    self:UnregisterEvent("UNIT_FLAGS")
    self:UnregisterEvent("UNIT_PET")
  end
end

local function element_UpdateSize(self)
  local width = self._config.width
  local height = self._config.height
  self:SetSize(width, height)

  self.Bar.Overlay:ClearAllPoints()
  self.Bar.Overlay:SetPoint("TOPLEFT", self, E.SCREEN_SCALE * 3, -E.SCREEN_SCALE * 3)
  self.Bar.Overlay:SetPoint("BOTTOMRIGHT", self, -E.SCREEN_SCALE * 3, -4)
end

function BARS.HasThreatBar()
  return isInit
end

function BARS.CreateThreatBar()
  if not isInit and C.db.profile.modules.bars.threatbar.enabled then
    local element = CreateFrame("Frame", "LumThreatBar", UIParent)
    element._id = "threatbar"
    element.list = {}

    BARS:AddBar(element._id, element)

    local texParent = CreateFrame("Frame", nil, element)
    texParent:SetAllPoints()
    texParent:SetFrameLevel(element:GetFrameLevel() + 10)
    element.TexParent = texParent

    local bar = E:CreateStatusBar(bar, "$parentStatusbar")
    bar:SetAllPoints(element)
    bar:SetFrameLevel(5)
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(0.5)
    bar:SetStatusBarColor(E:GetRGB(C.db.global.colors.threat[1]))
    bar.Bg:SetAlpha(0.3)
    bar.Overlay =
      E:SetBackdrop(
      texParent,
      E.SCREEN_SCALE * 3,
      0.98,
      nil,
      {
        bgFile = M.textures.vertlines,
        tile = true,
        tileSize = 8
      }
    )
    bar.Overlay:SetBackdropColor(E:GetRGBA(C.db.global.backdrop.color))
    element.Bar = bar
    E:SmoothBar(bar)
    bar:Hide()

    element.Update = element_Update
    element.UpdateSize = element_UpdateSize
    element.UpdatePoints = element_UpdatePoints
    element.GetLargestThreatOnList = element_GetLargestThreatOnList

    element:SetScript("OnEvent", element_OnEvent)

    element:RegisterEvent("PLAYER_TARGET_CHANGED")
    element:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
    element:RegisterEvent("GROUP_ROSTER_UPDATE")
    element:RegisterEvent("UNIT_FLAGS")
    element:RegisterEvent("UNIT_PET")

    element:Update()

    isInit = true
  end
end
