function wait(m)
  os.execute("sleep "..m)
end
function cls()
  os.execute("clear")
end

local simulationCooldown = 0.3
local frmCount = 0
local outputFile= "frames.txt"
local saving = true
local clearOldData = true
local cells = {}
local frames = {}
local maxX, maxY = 20, 20

for x=1,maxY,1 do
  for y=1,maxX,1 do
    cells[tostring(x)..","..tostring(y)] = false
  end
end

local function randomize() --broken
  for c_,v in pairs(cells) do
    if math.random(2,ma)/4 > 500 then
      r = true
    else
       r = false
    end
    cells[c_] = r
  end
end

local function clearOutputFile()
  local oup_ = io.open(outputFile,"w")
  local file = io.output(oup_)
  io.write("")
  io.close()
end

local function fileStart()
  local oup_ = io.open(outputFile,"a")
  local file = io.output(oup_)
  io.write("\n"..string.rep(" ",23).."\n")
  io.close()
end

local function isAlive(cx_,cy_)
  if cells[tostring(cx_)..","..tostring(cy_)] == true then
    return true
  else
    return false
  end
end

local function setLife(c_, bool) --for render/simulation function
  cells[c_] = bool
end

local function inputTable(tbl_, bool_) --2nd param optional
  if bool_ ~= nil then
    for _, cell_ in pairs(tbl_) do
      setLife(cell_,bool_)
    end
  else
    for _, cell_ in pairs(tbl_) do
      setLife(cell_,true)
    end
  end
end

local function getAliveNeighbors(cx_,cy_)
  local live = 0
  if cells[tostring(cx_-1)..","..tostring(cy_)] then --left
    live = live+1
  end
  if cells[tostring(cx_+1)..","..tostring(cy_)] then --right
    live = live+1
  end
  if cells[tostring(cx_)..","..tostring(cy_-1)] then --top
    live = live+1
  end
  if cells[tostring(cx_)..","..tostring(cy_+1)] then --bottom
    live = live+1
  end
  if cells[tostring(cx_-1)..","..tostring(cy_-1)] then --topleft
    live = live+1
  end
  if cells[tostring(cx_+1)..","..tostring(cy_-1)] then --topright
    live = live+1
  end
  if cells[tostring(cx_-1)..","..tostring(cy_+1)] then --bottomleft
    live = live+1
  end
  if cells[tostring(cx_+1)..","..tostring(cy_+1)] then --bottomright
    live = live+1
  end
  return live
end
--[[glider use inputTable() instead
cells[tostring(3)..","..tostring(3)] = true
cells[tostring(3)..","..tostring(2)] = true
cells[tostring(2)..","..tostring(3)] = true
cells[tostring(1)..","..tostring(2)] = true
cells[tostring(3)..","..tostring(1)] = true
]]
--[[blinker use inputTable() instead
toggleLife(3,1)
toggleLife(3,2)
toggleLife(3,3)]]

local function renderNoCalc()
 local frame = ""
 for y_ = 1,maxY+2,1 do
    local curLine = ""
    if y_ ~= maxY+2 and y_ ~= 1 then
      for x_ = 1,maxX+2,1 do
        if isAlive(x_-1, y_-1) then
          if x_ ~= maxX+2 and x_ ~= 1 then
            curLine = curLine.."[]"
          else
            curLine = curLine.."= "
          end
        else
          if x_ ~= maxX+2 and x_ ~= 1 then
            curLine = curLine.."- "
          else
            curLine = curLine.."= "
          end
        end
      end
    else
      curLine = curLine..string.rep("= ",maxY+2)
    end
    frame = frame..curLine.."\n"
  end
  print(frame)
end

local function render()
  local kill = {}
  local live = {}
  
  for y=1,maxY,1 do
    for x=1,maxX,1 do
      if isAlive(x, y) then
        if getAliveNeighbors(x,y) < 2 then
          table.insert(kill,tostring(x)..","..tostring(y))
        elseif getAliveNeighbors(x,y) == 3 or getAliveNeighbors(x,y) == 2 then
          table.insert(live,tostring(x)..","..tostring(y))
        elseif getAliveNeighbors(x,y) > 3 then
          table.insert(kill,tostring(x)..","..tostring(y))
        end
      else
        if getAliveNeighbors(x,y) == 3 then
           table.insert(live,tostring(x)..","..tostring(y))
        end
      end
    end
  end

  for i,v in pairs(kill) do
    setLife(v,false)
  end

  for i,v in pairs(live) do
    setLife(v,true)
  end
  cls()
  local frame = ""
  for y_ = 1,maxY+2,1 do
    local curLine = ""
    if y_ ~= maxY+2 and y_ ~= 1 then
      for x_ = 1,maxX+2,1 do
        if isAlive(x_-1, y_-1) then
          if x_ ~= maxX+2 and x_ ~= 1 then
            curLine = curLine.."[]"
          else
            curLine = curLine.."= "
          end
        else
          if x_ ~= maxX+2 and x_ ~= 1 then
            curLine = curLine.."- "
          else
            curLine = curLine.."= "
          end
        end
      end
    else
      curLine = curLine..string.rep("= ",maxY+2)
    end
    frame = frame..curLine.."\n"
  end
  print(frame)
  print("frame: "..frmCount)
  if saving then
    local fil = io.open(outputFile,"a+")
    local file = io.output(fil)
    io.write(frmCount.."\n"..frame..'\n')
    io.close()
  end
  table.insert(frames,frmCount,frame)
end

local function startCountDown()
  cls()
  print('3')
  wait(1)
  cls()
  print('2')
  wait(1)
  cls()
  print('1')
  wait(1)
  cls()
end

local tab = {"3,3","3,2","2,3","1,2","3,1"}
inputTable(tab)

if saving then
  if clearOldData then
    clearOutputFile()
  end
  fileStart()
end

renderNoCalc()
startCountDown()

repeat
  wait(simulationCooldown)
  frmCount = frmCount+1
  render()
until true == false
