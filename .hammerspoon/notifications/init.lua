Dock = hs.axuielement.applicationElement('Dock'):attributeValue('AXChildren')

local module = {}
local imagesPath = hs.configdir .. '/notifications/images'

local icons = {
  Slack = hs.image.imageFromPath(imagesPath .. '/slack.png'),
  Spark = hs.image.imageFromPath(imagesPath .. '/mail.png'),
}

local menuBars = {}

local function numberToSuperscript(n)
  local numbers = {
    0x2070, -- ⁰
    0x00B9, -- ¹
    0x00B2, -- ²
    0x00B3, -- ³
    0x2074, -- ⁴
    0x2075, -- ⁵
    0x2076, -- ⁶
    0x2077, -- ⁷
    0x2078, -- ⁸
    0x2079, -- ⁹
  }
  local tmp = 0
  local res = ''

  while n > 0 do
    tmp = n%10
    n = n // 10
    res = utf8.char(numbers[tmp+1]) .. res
  end

  return res
end

local function updateNotifications()
  for _, v in pairs(Dock[1].AXChildren) do
    local title = v:attributeValue('AXTitle')
    if menuBars[title] ~= nil then
      local label = tonumber(v:attributeValue('AXStatusLabel')) or '0'
      if label == '0' then
        menuBars[title]:setTitle(nil)
        -- menuBars[title]:removeFromMenuBar()
      else
        if not menuBars[title]:isInMenuBar() then
          menuBars[title]:returnToMenuBar():imagePosition(hs.menubar.imagePositions['imageLeft'])
          menuBars[title]:setIcon(icons[title])
          
          menuBars[title]:setClickCallback(function()
            menuBars[title]:setTitle(nil)
            menuBars[title]:removeFromMenuBar()
            hs.application.launchOrFocus(title)
          end)
        end
        menuBars[title]:setTitle(numberToSuperscript(label))
      end
    end
  end
end

function module.start()
  for key, value in pairs(icons) do
    menuBars[key] = hs.menubar.new()
    menuBars[key]:setIcon(icons[key])

    menuBars[key]:setClickCallback(function()
      menuBars[key]:setTitle(nil)
      hs.application.launchOrFocus(key)
    end)
  end

  updateNotifications()

  myTimer = hs.timer.new(60, updateNotifications)
  myTimer:start()
end

return module