function widget:GetInfo()
  return {
    name      = "Lane Graphics",
    desc      = "Lane Graphics",
    author    = "-",
    date      = "",
    license   = "GNU GPL, v2 or later",
    layer     = -9,
    enabled   = true
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

VFS.Include("luahelpers/main.lua")

local mapX = Game.mapSizeX
local mapZ = Game.mapSizeZ

local glColor            = gl.Color
local glDepthTest        = gl.DepthTest
local glVertex           = gl.Vertex
local glBeginEnd         = gl.BeginEnd
local glRotate           = gl.Rotate
local glPopMatrix        = gl.PopMatrix
local glPushMatrix       = gl.PushMatrix
local glTranslate        = gl.Translate
local glCallList         = gl.CallList
local glCreateList       = gl.CreateList

local spGetGameFrame = Spring.GetGameFrame
local spTraceScreenRay = Spring.TraceScreenRay
local spGetGroundOrigHeight = Spring.GetGroundOrigHeight


local lanesList


local arrowOptions = {
  thickness = 20,
  spacing = 20,
  width = 100,
}


local rgbColors = {
  ['base03'] = { 0, 43, 54 },
  ['base02'] = { 7, 54, 66 },
  ['base01'] = { 88, 110, 117 },
  ['base00'] = { 101, 123, 131 },
  ['base0'] = { 131, 148, 150 },
  ['base1'] = { 147, 161, 161 },
  ['base2'] = { 238, 232, 213 },
  ['base3'] = { 253, 246, 227 },
  ['yellow'] = { 181, 137, 0 },
  ['orange'] = { 203, 75, 22 },
  ['red'] = { 220, 50, 47 },
  ['magenta'] = { 211, 54, 130 },
  ['violet'] = { 108, 113, 196 },
  ['blue'] = { 38, 139, 210 },
  ['cyan'] = { 42, 161, 152 },
  ['green'] = { 133, 153, 0 } }

local highlights = {
  [0] = { 181, 137, 0 },
  [1] = { 203, 75, 22 },
  [2] = { 220, 50, 47 },
  [3] = { 211, 54, 130 },
  [4] = { 108, 113, 196 },
  [5] = { 38, 139, 210 },
  [6] = { 42, 161, 152 },
  [7] = { 133, 153, 0 }
}

local opacities = {
  0.08,
  0.15,
  0.22,
  0.35,
  0.45,
  0.6,
  1
}
local laneWidth = 800
local startingAreaWidth = 1500

local laneAreas = {
  {
    ['left_top'] = { ['x'] = startingAreaWidth, ['z'] = startingAreaWidth + laneWidth},
    ['right_top'] = { ['x'] = startingAreaWidth+laneWidth, ['z'] = mapZ},
    ['left_bottom'] = { ['x'] = startingAreaWidth, ['z'] = mapZ},
    ['right_bottom'] = { ['x'] = startingAreaWidth+laneWidth, ['z'] = startingAreaWidth+laneWidth},
    ['direction'] = 'up',
    ['order'] = 'first'
  },
  {
    ['left_top'] = { ['x'] = startingAreaWidth, ['z'] = startingAreaWidth },
    ['right_top'] = { ['x'] = mapX - startingAreaWidth - laneWidth, ['z'] = startingAreaWidth },
    ['left_bottom'] = { ['x'] = startingAreaWidth, ['z'] = startingAreaWidth + laneWidth },
    ['right_bottom'] = { ['x'] = mapX - startingAreaWidth - laneWidth, ['z'] = startingAreaWidth + laneWidth },
    ['direction'] = 'right'
  },
  {
    ['left_top'] = { ['x'] = mapX - startingAreaWidth - laneWidth, ['z'] = startingAreaWidth },
    ['right_top'] = { ['x'] = mapX - startingAreaWidth, ['z'] = startingAreaWidth },
    ['left_bottom'] = { ['x'] = mapX - startingAreaWidth - laneWidth, ['z'] = mapZ - startingAreaWidth - laneWidth },
    ['right_bottom'] = { ['x'] = mapX - startingAreaWidth, ['z'] = mapZ - startingAreaWidth - laneWidth},
    ['direction'] = 'down'
  },
  {
    ['left_top'] = { ['x'] = 2 * startingAreaWidth + 2 * laneWidth, ['z'] = mapZ - startingAreaWidth - laneWidth },
    ['right_top'] = { ['x'] = mapX - startingAreaWidth, ['z'] = mapZ - startingAreaWidth - laneWidth },
    ['left_bottom'] = { ['x'] = 2 * startingAreaWidth + 2 * laneWidth, ['z'] = mapZ - startingAreaWidth },
    ['right_bottom'] = { ['x'] = mapX - startingAreaWidth, ['z'] = mapZ - startingAreaWidth },
    ['direction'] = 'left'
  },
  {
    ['left_top'] = { ['x'] = 2 * startingAreaWidth + 1 * laneWidth, ['z'] = 2*startingAreaWidth + 2*laneWidth },
    ['right_top'] = { ['x'] = 2 * startingAreaWidth + 2 * laneWidth, ['z'] = 2 * startingAreaWidth + 2 * laneWidth },
    ['left_bottom'] = { ['x'] = 2 * startingAreaWidth + 1 * laneWidth, ['z'] = mapZ - startingAreaWidth },
    ['right_bottom'] = { ['x'] = 2 * startingAreaWidth + 2 * laneWidth, ['z'] = mapZ - startingAreaWidth },
    ['direction'] = 'up',
    ['order'] = 'last'
  }
}

function GLDrawArrowNumber(i)
  glBeginEnd(GL.QUAD_STRIP, function()
    local forwardOffset = i * (arrowOptions.spacing + arrowOptions.thickness)
    local fowardOffsetWidth = forwardOffset + arrowOptions.thickness
    glVertex(0, 0, forwardOffset)
    glVertex(0, 0, fowardOffsetWidth)
    glVertex(arrowOptions.width, 0, forwardOffset + arrowOptions.width - 2 * arrowOptions.thickness)
    glVertex(arrowOptions.width, 0, forwardOffset + arrowOptions.width - arrowOptions.thickness)
    glVertex(arrowOptions.width + arrowOptions.width, 0, forwardOffset)
    glVertex(arrowOptions.width + arrowOptions.width, 0, fowardOffsetWidth)
  end)
end

function GLDrawArrow()
  glBeginEnd(GL.QUAD_STRIP, function()
    glVertex(0, 0, 0)
    glVertex(0, 0, arrowOptions.thickness)
    glVertex(arrowOptions.width, 0, 0 + arrowOptions.width - 2 * arrowOptions.thickness)
    glVertex(arrowOptions.width, 0, 0 + arrowOptions.width - arrowOptions.thickness)
    glVertex(arrowOptions.width + arrowOptions.width, 0, 0)
    glVertex(arrowOptions.width + arrowOptions.width, 0, arrowOptions.thickness)
  end)
end


function DrawMarker(x, y)
  log('DrawMarker ('.. x .. ', ' .. y .. ')' )
  glPushMatrix()
  glTranslate(x, 101, y)
  glDepthTest(GL.LEQUAL)
  glBeginEnd(GL.QUADS, function()
    glVertex(-30, 0, -30)
    glVertex(-30, 0, 30)
    glVertex(30, 0, 30)
    glVertex(30, 0, -30)
  end)
  glPopMatrix()
end

function GLDrawAreaSideLanes(laneArea, nextArea)
  local outerLength, innerLength, outerStartPos, innerStartPos, degree, deltaX, deltaZ = getLaneInfo(laneArea, nextArea)

  local maxHeight = math.max(
    spGetGroundOrigHeight(laneArea.left_top.x, laneArea.left_top.z),
    spGetGroundOrigHeight(laneArea.right_top.x, laneArea.right_top.z),
    spGetGroundOrigHeight(laneArea.left_bottom.x, laneArea.left_bottom.z),
    spGetGroundOrigHeight(laneArea.right_bottom.x, laneArea.right_bottom.z)
  ) + 2

  local arrowStripWidth = 2 * arrowOptions.width


  local currPosX = outerStartPos.x
  local currPosZ = outerStartPos.z
  local nOuterArrows = math.floor(outerLength / (arrowOptions['spacing'] + arrowOptions['thickness']))
  for arrow = 0, nOuterArrows do
    glPushMatrix()
--    glTranslate(outerLength, 0, 0)
--    glTranslate(0, 0, 0)
    if degree == 0 then
      glTranslate(currPosX - arrowStripWidth, maxHeight, currPosZ + arrowStripWidth)
    elseif degree == 90 then
      glTranslate(currPosX + arrowStripWidth, maxHeight, currPosZ + arrowStripWidth)
    elseif degree == 180 then
      glTranslate(currPosX + arrowStripWidth, maxHeight, currPosZ - (laneArea.order == 'first' and 0 or arrowStripWidth))
    elseif degree == 270 then
      glTranslate(currPosX - arrowStripWidth, maxHeight, currPosZ - arrowStripWidth)
    end
    glRotate(degree, 0, 1, 0)
    GLDrawArrow()
--    glTranslate(0, maxHeight, 0)
--    glTranslate(0, 0, 0)
    glPopMatrix()
    currPosX = currPosX + deltaX
    currPosZ = currPosZ + deltaZ
  end


  local currPosX = innerStartPos.x
  local currPosZ = innerStartPos.z
  log(innerLength)

  local nInnerArrows = math.floor(innerLength / (arrowOptions['spacing'] + arrowOptions['thickness']))
  local transX
  local transZ
log('nInnerArrows for lane ' .. nInnerArrows)
  for arrow = 0, nInnerArrows do
    glPushMatrix()
      if degree == 0 then
        transX = currPosX - arrowStripWidth
        transZ = currPosZ + arrowStripWidth
      elseif degree == 90 then
        transX = currPosX + arrowStripWidth
        transZ = currPosZ + arrowStripWidth
      elseif degree == 180 then
        transX = currPosX + arrowStripWidth
        transZ = currPosZ - (laneArea.order == 'first' and 0 or arrowStripWidth)
      elseif degree == 270 then
        transX = currPosX - arrowStripWidth
        transZ = currPosZ - arrowStripWidth
      end
      log('translating to ' .. transX .. ', '..transZ)
      glTranslate(transX, maxHeight, transZ)
      glRotate(degree, 0, 1, 0)
      GLDrawArrow()
    glPopMatrix()
    currPosX = currPosX + deltaX
    currPosZ = currPosZ + deltaZ
  end


  --    local nArrows = 4
--    for arrow = 0, nArrows do
--      for tailPart = 1, #opacities do
--        glColor(38/256, 139/256, 210/256, opacities[tailPart])
--        local drawPos = (frame) % (arrowListLength) + tailPart
--        local finalDrawPos = (drawPos + arrow * arrowListLength / nArrows) % arrowListLength
--        if finalDrawPos <= arrowListLength then
--          GLDrawArrow(finalDrawPos)
--        end
--      end
--    end
--  glPopMatrix()


end

function getLaneInfo(laneArea, nextArea)
  local outer
  local inner
  local outerStartPos
  local innerStartPos
  local degree
  local deltaX = 0
  local deltaZ = 0
--  local nextAreaWidth

--  log('table.tostring(laneArea) ' .. table.tostring(laneArea))
--  log('table.tostring(nextArea) ' .. table.tostring(nextArea))
  if laneArea.direction == 'up' then
    outer = laneArea.left_top.z - laneArea.left_bottom.z
    inner = outer - (nextArea and math.abs(nextArea.left_top.z - nextArea.left_bottom.z) or 0)
    outerStartPos = laneArea.left_bottom
    innerStartPos = {['x'] = laneArea.right_bottom.x, ['z'] = laneArea.right_bottom.z - (laneArea.order == 'first' and 0 or laneWidth)}
--    innerStartPos = {['x'] = laneArea.right_bottom.x, ['z'] = laneArea.right_bottom.z - (laneArea.order == 'first' and 0 or laneWidth)}
    degree = 180
    deltaZ = -(arrowOptions.thickness + arrowOptions.spacing)
  elseif laneArea.direction == 'right' then
    outer = laneArea.right_top.x - laneArea.left_top.x
    inner = outer - (nextArea and math.abs(nextArea.left_top.x - nextArea.right_top.x) or 0)
    outerStartPos = laneArea.left_top
    innerStartPos = {['x'] = laneArea.left_bottom.x + laneWidth, ['z'] = laneArea.left_bottom.z}
    degree = 90
    deltaX = (arrowOptions.thickness + arrowOptions.spacing)
  elseif laneArea.direction == 'down' then
    outer = laneArea.right_top.z - laneArea.right_bottom.z
    inner = outer - (nextArea and math.abs(nextArea.left_top.z - nextArea.left_bottom.z) or 0)
    outerStartPos = laneArea.right_top
    innerStartPos = {['x'] = laneArea.left_top.x, ['z'] = laneArea.left_top.z + laneWidth }
    degree = 0
    deltaZ = (arrowOptions.thickness + arrowOptions.spacing)
  elseif laneArea.direction == 'left' then
    outer = laneArea.right_bottom.x - laneArea.left_bottom.x
    inner = outer - (nextArea and math.abs(nextArea.left_top.x - nextArea.right_top.x) or 0)
    outerStartPos = laneArea.right_bottom
    innerStartPos = {['x'] =  laneArea.right_top.x - laneWidth, ['z'] = laneArea.right_top.z }
    degree = 270
    deltaX = -(arrowOptions.thickness + arrowOptions.spacing)
  end

  -- pixel pushing :3
  outer = math.abs(outer) + (laneArea.order == 'last' and 0 or laneWidth) - (laneArea.order == 'first' and 0 or 2 * arrowOptions.width) - 2*(arrowOptions.spacing +
  arrowOptions.thickness)
  inner = math.abs(inner)

  return outer, inner, outerStartPos, innerStartPos, degree, deltaX, deltaZ
end


function widget:Initialize()
    lanesList = glCreateList(function()
      glDepthTest(GL.LEQUAL)
      for i = 1, #laneAreas do
        local r = i % #highlights
        glColor(highlights[r][1]/256, highlights[r][2]/256, highlights[r][3]/256, 0.6)
        log('GLDrawAreaSideLanes '..i)
--        glColor(rgbColors['blue'][1] / 256, rgbColors['blue'][2] / 256, rgbColors['blue'][3] / 256, 0.3)
        GLDrawAreaSideLanes(laneAreas[i], i < #laneAreas and laneAreas[i+1] or nil)
      end
    end)
end

function widget:MousePress(x, z, button)
  local _, pos = spTraceScreenRay(x, z, true)
--  log('max values ' .. mapX .. ' ' .. mapZ)
  if not pos then
    return
  end
  log('pressed ' .. math.floor(pos[1]) .. '/' .. mapX .. ' ' .. math.floor(pos[3]) .. '/' .. mapZ .. ' height: ' .. pos[2] )
end

function widget:DrawWorld()
  glCallList(lanesList)
--[[
  glPushMatrix()
  for i = 1, #laneAreas do
    log('Markers laneArea ' .. i)
    local r = i % #highlights
    glColor(highlights[r][1]/256, highlights[r][2]/256, highlights[r][3]/256, 0.6)
    DrawMarker(laneAreas[i].left_bottom.x, laneAreas[i].left_bottom.z)
    DrawMarker(laneAreas[i].right_bottom.x, laneAreas[i].right_bottom.z)
    DrawMarker(laneAreas[i].left_top.x, laneAreas[i].left_top.z)
    DrawMarker(laneAreas[i].right_top.x, laneAreas[i].right_top.z)
--    GLDrawAreaSideLanes(i,laneAreas)
  end
  glPopMatrix()
  ]]


  --      local nArrows = 4
  --      for arrow = 0, nArrows do
  --        for tailPart = 1, #opacities do
  --          glColor(38/256, 139/256, 210/256, opacities[tailPart])
  --          local drawPos = (frame) % (arrowListLength) + tailPart
  --          local finalDrawPos = (drawPos + arrow * arrowListLength / nArrows) % (arrowListLength)
  --          if finalDrawPos <= arrowListLength then
  --            DrawArrow(finalDrawPos)
  --          end
  --        end
  --      end
end
