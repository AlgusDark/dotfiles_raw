local eventtap = hs.eventtap
local eventTypes = eventtap.event.types
local keycodes = hs.keycodes.map
-- local windowFilter = hs.window.filter

local module = {}

local function tableSize(t)
  local count = 0
  for _, __ in pairs(t) do
      count = count + 1
  end
  return count
end

local function cmd2CtrlEventHandler(event)
  local flags = event:getFlags()
  local keycode = event:getKeyCode()
  local flagsSize = tableSize(flags)

  if(flagsSize > 1 or not flags.cmd) then return false end

  if flags.cmd then
    if keycode == keycodes.space or keycode == keycodes.tab then
      return false
    end
    flags.cmd = false
    flags.ctrl = true
  end

  if keycode == keycodes.cmd then
    keycode = keycodes.ctrl
  elseif keycode == keycodes.rightcmd then
    keycode = keycodes.rightctrl
  end

  event:setKeyCode(keycode):setFlags(flags)

  return false
end

local cmd2CtrlEventTapObj = eventtap.new({
  eventTypes.flagsChanged,
  eventTypes.keyDown,
  eventTypes.keyUp
}, cmd2CtrlEventHandler)

local watcher = hs.application.watcher.new(function(applicationName, eventType)
  if applicationName ~= "WezTerm" then return end

  if eventType == hs.application.watcher.activated then
    cmd2CtrlEventTapObj:start()
  elseif eventType == hs.application.watcher.deactivated then
    cmd2CtrlEventTapObj:stop()
  end
end)

function module.start()
  watcher:start()
  -- windowFilter.new('WezTerm')
  -- :subscribe(windowFilter.windowFocused, function() cmd2CtrlEventTapObj:start() end)
  -- :subscribe(windowFilter.windowUnfocused, function() cmd2CtrlEventTapObj:stop() end)
end

function module.stop()
  watcher:stop()
end

return module