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

--local s = assert(VFS.LoadFile("luahelpers/main.lua", VFS.RAW_FIRST))
--local chunk = assert(loadstring(s, file))
--setfenv(chunk, gadget)
--chunk()

local mapX = Game.mapSizeX
local mapZ = Game.mapSizeZ

local glColor            = gl.Color
local glDepthTest        = gl.DepthTest
local glScale            = gl.Scale
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

local arrowListLength = 100
local arrowList

local arrowOptions = {
  thickness = 20,
  spacing = 20,
  width = 100,
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

local laneDefPositions = {
    -- from spawn to end, left (x,y) positions first
--    {
--      {startingAreaWidth, mapZ}, -- left spawn corner
--      {startingAreaWidth+laneWidth, mapZ}, -- right spawn corner
--      {startingAreaWidth, startingAreaWidth+laneWidth}, -- left end corner
--      {startingAreaWidth+laneWidth,startingAreaWidth+laneWidth}, -- right end corner
--      {180} -- angle
--    },
    {
--      {2627, mapZ},
--      {2627+laneWidth, mapZ},
--      {2627+laneWidth, mapZ},
      {startingAreaWidth, mapZ}, -- left spawn corner
      {startingAreaWidth+laneWidth, mapZ}, -- right spawn corner
      {startingAreaWidth, startingAreaWidth+laneWidth}, -- left end corner
      {startingAreaWidth+laneWidth,startingAreaWidth+laneWidth}, -- right end corner
      {180} -- angle
    }
}


VFS.Include("luahelpers/main.lua")

local frame

local function DrawLaneLine(length)
  for i = 0, length-1 do
    DrawArrow(i)
  end
end

function DrawArrow(i)
  glBeginEnd(GL.QUAD_STRIP, function()
    local forwardOffset = i*(arrowOptions.spacing+arrowOptions.thickness)
    local fowardOffsetWidth = forwardOffset + arrowOptions.thickness
    glVertex(0,0,forwardOffset)
    glVertex(0,0,fowardOffsetWidth)
    glVertex(arrowOptions.width,0,forwardOffset+arrowOptions.width-2*arrowOptions.thickness)
    glVertex(arrowOptions.width,0,forwardOffset+arrowOptions.width-arrowOptions.thickness)
    glVertex(arrowOptions.width+arrowOptions.width,0,forwardOffset)
    glVertex(arrowOptions.width+arrowOptions.width,0, fowardOffsetWidth)
  end)
end

function DrawLane(lanePos)

  frame = spGetGameFrame()
--  log(table.tostring(lanePosition))
  glPushMatrix()
--    glTranslate(50,31,50)
    glTranslate(lanePos[1][1], 31, lanePos[1][2])
    glRotate(180,0,1,0)
  --    log(lanePositions[1][1])
  --    log(x)
  --    log(y)
  --    log(z)
    glColor(38/256, 139/256, 210/256, 0.3)
    glDepthTest(GL.LEQUAL)
    glCallList(arrowList)

    local nArrows = 4
    for arrow = 0, nArrows do
      for tailPart = 1, #opacities do
        glColor(38/256, 139/256, 210/256, opacities[tailPart])
        local drawPos = (frame) % (arrowListLength) + tailPart
        local finalDrawPos = (drawPos + arrow * arrowListLength / nArrows) % (arrowListLength)
        if finalDrawPos <= arrowListLength then
          DrawArrow(finalDrawPos)
        end
      end
    end
  glPopMatrix()


end

function getLaneLengths(laneDef)
end

function widget:Initialize()
  log(table.tostring(laneDefPositions))

--  log(laneDefPositions[1][1][1]-laneDefPositions[1][2][1]) -- x1
--  log(laneDefPositions[1][1][1]-laneDefPositions[1][3][1])
--  log(laneDefPositions[1][1][1]-laneDefPositions[1][3][1])
--  log(laneDefPositions[1][1][1]-laneDefPositions[1][3][1])
--  log(laneDefPositions[1][1][1]-laneDefPositions[1][3][1])
  for k, v in pairs(laneDefPositions) do
--    log(table.tostring(laneDefPositions[1][3][1]))
--    left edge
    local length = getLaneLengths(laneDefPositions[1][3])
    local x_end = laneDefPositions[1][3][2]
    local x_start = laneDefPositions[1][1][2]
    local laneLength = x_end - x_start
    log('laneLength'..x_end .. ' '..x_start)
    arrowList = glCreateList(DrawLaneLine, (laneLength)/(arrowOptions.thickness+arrowOptions.spacing))
    arrowList = glCreateList(DrawLaneLine, (laneDefPositions[1][3][1] - laneDefPositions[1][1][3])/(arrowOptions.thickness+arrowOptions.spacing))
  end

end

function widget:MousePress(x, y, button)
  local _, pos = spTraceScreenRay(x, y, true)
  log('max values '.. mapX.. ' '.. mapZ)
  log('pressed '..math.floor(pos[1]).. '/'.. mapX ..' '..math.floor(pos[3]) .. '/'..mapZ)
end




function widget:DrawWorld()
--  DrawLane(laneDefPositions[1])

--  if not arrowList then
--    arrowList = glCreateList(DrawLaneLine, arrowListLength)
--  log(#lanePositions)
--    for k, lanePosition in ipairs(lanePositions) do
--
--    end
--
--  end
--[[

  frame = springGetGameFrame()
  glPushMatrix()
--    glTranslate(5000,31,5000)
    glTranslate(lanePositions[1][1][1], 31, lanePositions[1][1][2])
    glRotate(180,0,1,0)
--    log(lanePositions[1][1])
--    log(x)
--    log(y)
--    log(z)
    glColor(38/256, 139/256, 210/256, 0.3)
    glDepthTest(GL.LEQUAL)
    glCallList(arrowList[1])

    local nArrows = 4
    for arrow = 0, nArrows do
      for tailPart = 1, #opacities do
        glColor(38/256, 139/256, 210/256, opacities[tailPart])
        local drawPos = (frame) % (arrowListLength) + tailPart
        local finalDrawPos = (drawPos + arrow * arrowListLength / nArrows) % (arrowListLength)
        if finalDrawPos <= arrowListLength then
          DrawArrow(finalDrawPos)
        end
      end
    end
  glPopMatrix()
]]

end


function log(val)
  Spring.Echo(val)
end
--[[

function table.has_value(tab, val)
    for _, value in ipairs (tab) do
        if value == val then
            return true
        end
    end
    return false
end

function table.full_of(tab, val)
    for _, value in ipairs (tab) do
        if value ~= val then
            return false
        end
    end
    return true
end

-- for printing tables
function table.val_to_str(v)
  if "string" == type(v) then
    v = string.gsub(v, "\n", "\\n" )
    if string.match(string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type(v) and table.tostring(v) or
      tostring(v)
  end
end

function table.key_to_str(k)
  if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str(k) .. "]"
  end
end

function table.tostring(tbl)
  local result, done = {}, {}
  for k, v in ipairs(tbl ) do
    table.insert(result, table.val_to_str(v) )
    done[ k ] = true
  end
  for k, v in pairs(tbl) do
    if not done[ k ] then
      table.insert(result,
        table.key_to_str(k) .. "=" .. table.val_to_str(v) )
    end
  end
  return "{" .. table.concat(result, "," ) .. "}"
end
]]
