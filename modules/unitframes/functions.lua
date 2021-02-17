local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local next = _G.next

-- ---------------

-- Shared Styles
do
  local configIgnoredKeys = {
    alt_power = true,
    auras = true,
    border = true,
    castbar = true,
    class = true,
    class_power = true,
    combat_feedback = true,
    debuff = true,
    health = true,
    name = true,
    portrait = true,
    power = true,
    pvp = true,
    raid_target = true,
    threat = true
  }

  local function frame_OnEnter(self)
    self = self.__owner or self
    UnitFrame_OnEnter(self)
  end

  local function frame_OnLeave(self)
    self = self.__owner or self
    UnitFrame_OnLeave(self)
  end

  local function frame_UpdateConfig(self)
    local config = C.db.profile.unitframes.units
    self._config = E:CopyTable(config[self._layout or self._unit], self._config, configIgnoredKeys)
  end

  local function frame_UpdateSize(self)
    local width, height = self._config.width, self._config.height

    self:SetSize(width, height)

    if self.TextParent then
      self.TextParent:SetSize(width - 8, height)
    end
  end

  local function frame_ForElement(self, element, method, ...)
    if self[element] and self[element][method] then
      self[element][method](self[element], ...)
    end
  end

  function UF:SetSharedStyle(frame, unit)
    frame:RegisterForClicks("AnyUp")
    frame:SetScript("OnEnter", frame_OnEnter)
    frame:SetScript("OnLeave", frame_OnLeave)

    E:SetBackdrop(frame, E.SCREEN_SCALE * 3)
    if C.db.global.shadows.enabled then
      E:CreateShadow(frame)
    end

    frame._unit = unit:gsub("%d+", "")
    frame._layout = frame:GetName():match("Lum(%a+)Frame"):lower()

    frame.ForElement = frame_ForElement
    frame.UpdateConfig = frame_UpdateConfig
    frame.UpdateSize = frame_UpdateSize
  end
end

function UF:UpdateColors()
  self:UpdateHealthColors()
  self:UpdatePowerColors()
  self:UpdateReactionColors()
end

function UF:UpdateHealthColors()
  local color = oUF.colors.health
  color[1], color[2], color[3] = E:GetRGB(C.db.global.colors.health)

  color = oUF.colors.tapped
  color[1], color[2], color[3] = E:GetRGB(C.db.global.colors.tapped)

  color = oUF.colors.disconnected
  color[1], color[2], color[3] = E:GetRGB(C.db.global.colors.disconnected)

  oUF.colors.smooth = C.db.global.colors.smooth
end

function UF:UpdatePowerColors()
  local color = oUF.colors.power
  for k, myColor in next, C.db.global.colors.power do
    if type(k) == "string" then
      if not color[k] then
        color[k] = {}
      end

      if type(myColor[1]) == "table" then
        for i, myColor_ in next, myColor do
          color[k][i][1], color[k][i][2], color[k][i][3] = E:GetRGB(myColor_)
        end
      else
        color[k][1], color[k][2], color[k][3] = E:GetRGB(myColor)
      end
    end
  end

  color = oUF.colors.runes
  for k, v in next, C.db.global.colors.runes do
    color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
  end
end

function UF:UpdateReactionColors()
  local color = oUF.colors.reaction
  for k, v in next, C.db.global.colors.reaction do
    color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
  end
end

-- Sets frame state-visibility
function UF:SetStateVisibility(frame)
  if not frame then
    return
  end

  if frame._config.visibility then
    frame:Disable()
    RegisterAttributeDriver(frame, "state-visibility", frame._config.visibility)
  elseif not frame:IsEnabled() then
    frame:Enable()
  end
end
