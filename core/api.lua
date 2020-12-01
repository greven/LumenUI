local _, ns = ...
local E, M = ns.E, ns.M

-- Fontstring
-- function E:CreateString(text, size, color, anchor, x, y)
--   local fs = self:CreateFontString(nil, "OVERLAY")
--   fs:SetFont(, size, "THINOUTLINE")
-- end

function E:CreateBorder(parent, drawLayer, drawLevel)
end

function E:CreateBackdrop(size, override)
end

-- Backdrop shadow
function E:CreateShadow(size, override)
end

-- Glow parent
function E:CreateGlow(size)
  local frame = CreateFrame("Frame", nil, self)
  frame:SetPoint("CENTER")
  frame:SetSize(size+8, size+8)
  return frame
end
