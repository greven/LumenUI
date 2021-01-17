local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- Lua
local _G = getfenv(0)

-- ---------------

function E:CreateBackdrop(offset, alpha)
  local frame = self
  if self:GetObjectType() == "Texture" then frame = self:GetParent() end

  if not frame._backdrop then
    local level = frame:GetFrameLevel()
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetFrameLevel(level == 0 and 0 or level - 1)
    backdrop:SetOutside(frame, offset, offset)
    backdrop:SetBackdrop({bgFile = M.textures.flat, tile = false})
    if alpha then
      backdrop:SetBackdropColor(0, 0, 0, alpha)
    else
      backdrop:SetBackdropColor(E:GetRGBA(C.global.backdrop.color, C.global.backdrop.alpha))
    end

    frame._backdrop = backdrop
    return backdrop
  end
end

function E:SetBackdrop(offset, alpha, x1, y1, x2, y2)
  local bg = E.CreateBackdrop(self, offset, alpha)
  if x1 then
    bg:SetPoint("TOPLEFT", self, x1, y1)
		bg:SetPoint("BOTTOMRIGHT", self, x2, y2)
  end
  return bg
end

-- Backdrop shadow
function E:CreateShadow(size, alpha)
  if self._shadow then return end

  local frame = self
  if self:GetObjectType() == "Texture" then frame = self:GetParent() end

  local shadowBackdrop = {edgeFile = M.textures.glow}
  shadowBackdrop.edgeSize = size or 5
  self._shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
  self._shadow:SetOutside(self, size or 5, size or 5)
  self._shadow:SetBackdrop(shadowBackdrop)
  self._shadow:SetBackdropBorderColor(0, 0, 0, C.global.shadows.alpha)
  self._shadow:SetFrameLevel(1)

	return self._shadow
end

-- Glow parent
function E:CreateGlow(size)
  local frame = CreateFrame("Frame", nil, self)
  frame:SetPoint("CENTER")
  frame:SetSize(size+8, size+8)
  return frame
end
