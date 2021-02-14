-- Credits: ls_UI
local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

-- Lua
local _G = getfenv(0)
local assert = _G.assert
local hooksecurefunc = _G.hooksecurefunc
local m_floor = _G.math.floor
local next = _G.next
local s_format = _G.string.format
local s_upper = _G.string.upper
local t_insert = _G.table.insert
local t_remove = _G.table.remove
local t_wipe = _G.table.wipe
local type = _G.type
local unpack = _G.unpack

-- ---------------

local defaults = {}
local disabledMovers = {}
local enabledMovers = {}
local trackedMovers = {}
local highlightIndex = 0
local isDragging = false
local areToggledOn = false

E.Movers = {}

function E.Movers:Create(object, isSimple)
  if not object then
    return
  end

  local objectName = object:GetName()
  assert(objectName, (s_format("Failed to create a mover, object '%s' has no name", object:GetDebugName())))

  local name = objectName .. "Mover"

  local mover = CreateFrame("Button", name, UIParent)
  mover:SetFrameLevel(object:GetFrameLevel() + 4)
  mover:SetWidth(object:GetWidth())
  mover:SetHeight(object:GetHeight())
  mover:SetClampedToScreen(true)
  mover:SetClampRectInsets(-4, 4, 4, -4)
  mover:SetMovable(true)
  mover:SetToplevel(true)
  mover:RegisterForDrag("LeftButton")
  mover:SetScript("OnDragStart", mover_OnDragStart)
  mover:SetScript("OnDragStop", mover_OnDragStop)

  mover.object = object

  if isSimple then
    mover.isSimple = true
  else
    mover:SetScript("OnClick", mover_OnClick)
    mover:SetScript("OnEnter", mover_OnEnter)
    mover:SetScript("OnLeave", mover_OnLeave)
    mover:SetShown(areToggledOn)

    mover:SetHighlightTexture("Interface\\BUTTONS\\WHITE8X8")
    mover:GetHighlightTexture():SetAlpha(0.1)

    local bg = mover:CreateTexture(nil, "BACKGROUND", nil, 0)
    bg:SetColorTexture(E:GetRGBA(C.global.colors.blue, 0.6))
    bg:SetAllPoints()
    mover.Bg = bg

    mover.buttons = {
      createMoverButton(mover, "Up"),
      createMoverButton(mover, "Down"),
      createMoverButton(mover, "Left"),
      createMoverButton(mover, "Right")
    }
  end

  if not C.db.movers[name] then
    C.db.movers[name] = {}
  elseif C.db.movers[name].current then
    C.db.movers[name].point = {unpack(C.db.movers[name].current)}
    C.db.movers[name].current = nil
  end

  if not defaults[name] then
    defaults[name] = {}
  end

  defaults[name].point = {E:GetCoords(object)}

  E:UpdateTable(defaults[name], C.db.movers[name])

  mover.Disable = mover_Disable
  mover.Enable = mover_Enable
  mover.IsDragKeyDown = mover_IsDragKeyDown
  mover.IsEnabled = mover_IsEnabled
  mover.PostSaveUpdatePosition = E.NOOP
  mover.ResetPosition = mover_ResetPosition
  mover.SavePosition = mover_SavePosition
  mover.UpdatePosition = mover_UpdatePosition
  mover.UpdateSize = mover_UpdateSize
  mover.WasMoved = mover_WasMoved

  mover:UpdatePosition()

  enabledMovers[name] = mover

  hooksecurefunc(object, "SetPoint", resetObjectPoint)
  resetObjectPoint(object)

  return mover
end

E:AddCommand(
  "movers",
  function()
    E.Movers:ToggleAll()
  end
)
