local _, ns = ...
local E, C, L, oUF = ns.E, ns.C, ns.L, ns.oUF

local UF = E:GetModule("UnitFrames")

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
    self._config = E:CopyTable(C.modules.unitframes.units[self._layout or self._unit], self._config, configIgnoredKeys)
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

    local name = frame:GetName()
    frame._unit = unit:gsub("%d+", "")
    frame._layout = name:match("Lum(%a+)Frame"):lower()

    E:SetBackdrop(frame, E.SCREEN_SCALE * 3)
    E:CreateShadow(frame)

    frame.ForElement = frame_ForElement
    frame.UpdateConfig = frame_UpdateConfig
    frame.UpdateSize = frame_UpdateSize
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

function UF:UpdateHealthColors()
  local color = oUF.colors.health
  color[1], color[2], color[3] = E:GetRGB(C.colors.health)

  color = oUF.colors.tapped
  color[1], color[2], color[3] = E:GetRGB(C.colors.tapped)

  color = oUF.colors.disconnected
  color[1], color[2], color[3] = E:GetRGB(C.colors.disconnected)

  oUF.colors.smooth = C.colors.smooth
end

function UF:UpdatePowerColors()
  local color = oUF.colors.power
  for k, myColor in next, C.colors.power do
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
  for k, v in next, C.colors.runes do
    color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
  end
end

function UF:UpdateReactionColors()
  local color = oUF.colors.reaction
  for k, v in next, C.colors.reaction do
    color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
  end
end
