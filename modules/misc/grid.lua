local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local MISC = E:GetModule("Misc")

-- Lua
local _G = getfenv(0)
local m_floor = _G.math.floor
local next = _G.next
local t_insert = _G.table.insert
local t_remove = _G.table.remove

-- ---------------

local isInit = false

local linePool = {}
local activeLines = {}
local gridSize = 32
local areToggledOn = false
local Grid

local function getGridLine()
  if not next(linePool) then
    t_insert(linePool, Grid:CreateTexture())
  end

  local line = t_remove(linePool, 1)
  line:ClearAllPoints()
  line:Show()

  t_insert(activeLines, line)

  return line
end

local function releaseGridLines()
  while next(activeLines) do
    local line = t_remove(activeLines, 1)
    line:ClearAllPoints()
    line:Hide()

    t_insert(linePool, line)
  end
end

function MISC.HideGrid()
  Grid:Hide()
end

function MISC.ShowGrid()
  releaseGridLines()

  local screenWidth, screenHeight = UIParent:GetRight(), UIParent:GetTop()
  local screenCenterX, screenCenterY = UIParent:GetCenter()

  Grid:SetSize(screenWidth, screenHeight)
  Grid:SetPoint("CENTER")
  Grid:Show()

  local yAxis = getGridLine()
  yAxis:SetDrawLayer("BACKGROUND", 1)
  yAxis:SetColorTexture(0.9, 0.1, 0.1, 0.6)
  yAxis:SetPoint("TOPLEFT", Grid, "TOPLEFT", screenCenterX - 1, 0)
  yAxis:SetPoint("BOTTOMRIGHT", Grid, "BOTTOMLEFT", screenCenterX + 1, 0)

  local xAxis = getGridLine()
  xAxis:SetDrawLayer("BACKGROUND", 1)
  xAxis:SetColorTexture(0.9, 0.1, 0.1, 0.6)
  xAxis:SetPoint("TOPLEFT", Grid, "BOTTOMLEFT", 0, screenCenterY + 1)
  xAxis:SetPoint("BOTTOMRIGHT", Grid, "BOTTOMRIGHT", 0, screenCenterY - 1)

  local l = getGridLine()
  l:SetDrawLayer("BACKGROUND", 2)
  l:SetColorTexture(0.8, 0.8, 0.1, 0.6)
  l:SetPoint("TOPLEFT", Grid, "TOPLEFT", screenWidth / 3 - 1, 0)
  l:SetPoint("BOTTOMRIGHT", Grid, "BOTTOMLEFT", screenWidth / 3 + 1, 0)

  local r = getGridLine()
  r:SetDrawLayer("BACKGROUND", 2)
  r:SetColorTexture(0.8, 0.8, 0.1, 0.6)
  r:SetPoint("TOPRIGHT", Grid, "TOPRIGHT", -screenWidth / 3 + 1, 0)
  r:SetPoint("BOTTOMLEFT", Grid, "BOTTOMRIGHT", -screenWidth / 3 - 1, 0)

  -- horiz lines
  local tex
  for i = 1, m_floor(screenHeight / 2 / gridSize) do
    tex = getGridLine()
    tex:SetDrawLayer("BACKGROUND", 0)
    tex:SetColorTexture(0, 0, 0, 0.6)
    tex:SetPoint("TOPLEFT", Grid, "BOTTOMLEFT", 0, screenCenterY + 1 + gridSize * i)
    tex:SetPoint("BOTTOMRIGHT", Grid, "BOTTOMRIGHT", 0, screenCenterY - 1 + gridSize * i)

    tex = getGridLine()
    tex:SetDrawLayer("BACKGROUND", 0)
    tex:SetColorTexture(0, 0, 0, 0.6)
    tex:SetPoint("BOTTOMLEFT", Grid, "BOTTOMLEFT", 0, screenCenterY - 1 - gridSize * i)
    tex:SetPoint("TOPRIGHT", Grid, "BOTTOMRIGHT", 0, screenCenterY + 1 - gridSize * i)
  end

  -- vert lines
  for i = 1, m_floor(screenWidth / 2 / gridSize) do
    tex = getGridLine()
    tex:SetDrawLayer("BACKGROUND", 0)
    tex:SetColorTexture(0, 0, 0, 0.6)
    tex:SetPoint("TOPLEFT", Grid, "TOPLEFT", screenCenterX - 1 - gridSize * i, 0)
    tex:SetPoint("BOTTOMRIGHT", Grid, "BOTTOMLEFT", screenCenterX + 1 - gridSize * i, 0)

    tex = getGridLine()
    tex:SetDrawLayer("BACKGROUND", 0)
    tex:SetColorTexture(0, 0, 0, 0.6)
    tex:SetPoint("TOPRIGHT", Grid, "TOPLEFT", screenCenterX + 1 + gridSize * i, 0)
    tex:SetPoint("BOTTOMLEFT", Grid, "BOTTOMLEFT", screenCenterX - 1 + gridSize * i, 0)
  end
end

function MISC.SetUpGridLines()
  if not isInit then
    Grid = CreateFrame("Frame", nil, UIParent)
    Grid:SetFrameStrata("BACKGROUND")
    Grid:Hide()

    E:AddCommand(
      "grid",
      function()
        if not InCombatLockdown() then
          if not areToggledOn then
            MISC:ShowGrid()
            areToggledOn = true
          else
            MISC:HideGrid()
            areToggledOn = false
          end
        end
      end
    )

    isInit = true
  end
end
