local module = {}

--- Helper
local function __genOrderedIndex( t )
  local orderedIndex = {}
  for key in pairs(t) do
      table.insert( orderedIndex, key )
  end
  table.sort( orderedIndex )
  return orderedIndex
end

local function orderedNext(t, state)
  -- Equivalent of the next function, but returns the keys in the alphabetic
  -- order. We use a temporary ordered key table that is stored in the
  -- table being iterated.

  local key = nil
  --print("orderedNext: state = "..tostring(state) )
  if state == nil then
      -- the first time, generate the index
      t.__orderedIndex = __genOrderedIndex( t )
      key = t.__orderedIndex[1]
  else
      -- fetch the next value
      for i = 1,#t.__orderedIndex do
          if t.__orderedIndex[i] == state then
              key = t.__orderedIndex[i+1]
          end
      end
  end

  if key then
      return key, t[key]
  end

  -- no more value to return, cleanup
  t.__orderedIndex = nil
  return
end

local function orderedPairs(t)
  -- Equivalent of the pairs() function on tables. Allows to iterate
  -- in order
  return orderedNext, t, nil
end
---

module.format = {
  strokeWidth  = 2,
  strokeColor = { hex="#434C5F", alpha = 0.75 },
  fillColor   = { hex="#2E3440", alpha = 0.90 },
  textColor = { hex="#E5E9F0", alpha = 1 },
  textFont  = "JetBrainsMono Nerd Font",
  textSize  = 20,
  radius = 27,
  atScreenEdge = 0,
  fadeInDuration = 0.15,
  fadeOutDuration = 0.15,
  padding = nil,
}

module.entriesPerLine = 5

-- used by next model to close previous helper
local previousHelperID = nil
local currentMode = nil
local isCheatMode = false

module.maxLenght = 135

local modsMapping = {
  ctrl = '⌃',
  alt = '⌥',
  shift = '⇧',
  cmd = '⌘',
}

module.cheatSheet = {}

module.actions = {}

function module:init(mapActions)
  self.actions = mapActions
end

-- generate a string representation of a key spec
local function createKeyName(key, modifiers)
  if (not modifiers) then return key end
  local fmtKey = ''
  if(modifiers['ctrl']) then fmtKey = fmtKey .. '⌃ ' end
  if(modifiers['alt']) then fmtKey = fmtKey .. '⌥ ' end
  if(modifiers['shift']) then
    key = string.upper(key)
    fmtKey = fmtKey .. '⇧ '
  end
  if(modifiers['cmd']) then fmtKey = fmtKey .. '⌘ ' end
  
  return fmtKey .. '+ ' .. key
end

local function formatActions(modeEntry)
  local entriesPerLine = modeEntry.entriesPerLine or module.entriesPerLine
  local maxLenghtPerEntry = modeEntry.maxLenghtPerEntry or (module.maxLenght // entriesPerLine)
  local keys = modeEntry.keys
  local modifiers = modeEntry.modifiers
  -- keyFuncNameTable is a table that key is key name and value is description
  local helper = ''
  local separator = '' -- first loop doesn't need to add a separator, because it is in the very front. 
  local count = 0
  for key, description in orderedPairs(keys) do
     count = count + 1
     local newEntry = createKeyName(key, modifiers)..' => '..description
     -- make sure each entry is of the same length
     if string.len(newEntry) > maxLenghtPerEntry then
        newEntry = string.sub(newEntry, 1, maxLenghtPerEntry - 2)..'..'
     elseif string.len(newEntry) < maxLenghtPerEntry then
        newEntry = newEntry..string.rep(' ', maxLenghtPerEntry - string.len(newEntry))
     end
     -- create new line for every entriesPerLine entries
     if count % (entriesPerLine + 1) == 0 then
        count=1
        separator = '\n '
     elseif count == 1 then
        separator = ' '
     else
        separator = '  '
     end
     helper = helper..separator..newEntry
  end
  return helper
end

local function toTitleCase(str)
  str = str:gsub("%_", " ")
  str = str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
  return str
end

local function buildCheatSheet(mode)
  local actionMap = module.actions[mode]
  local str = ""
  for i, row in pairs(actionMap) do
    str = str .. ' ' .. row.title .. '\n\n' .. formatActions(row)
    if(i ~= #actionMap) then str = str .. '\n\n' end
  end
  return string.match(str, '[^\n].+$')
end

local function showCheatModal(mode)
  return hs.alert.show(buildCheatSheet(mode), module.format, true)
end

local function showSimpleModal(mode)
  return hs.alert.show(toTitleCase(mode), module.format, true)
end

local function closePreviousModal(mode)
  hs.alert.closeSpecific(previousHelperID)
  if(mode) then currentMode = mode end
end

local function ShowModal(mode)
  hs.alert.closeSpecific(previousHelperID)
  currentMode = mode

  if(isCheatMode) then
    previousHelperID = showCheatModal(mode)
  else
    previousHelperID = showSimpleModal(mode)
  end
end

function module:show(mode, cheatMode)
  if(cheatMode) then isCheatMode = true end
  ShowModal(mode)
end

function module:toggle()
  if(not module.actions[currentMode]) then return end

  isCheatMode = not isCheatMode
  hs.alert.closeSpecific(previousHelperID)
  ShowModal(currentMode)
end

function module:close()
  hs.alert.closeSpecific(previousHelperID)
  isCheatMode = false
end

return module