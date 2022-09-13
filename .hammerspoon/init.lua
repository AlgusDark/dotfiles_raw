hs.logger.defaultLogLevel="info"
require("hs.ipc")

if not hs.ipc.cliStatus() then
  if not hs.ipc.cliInstall() then
    hs.ipc.cliUninstall()
  end
end

hyper = {"cmd","alt","ctrl","shift"}
meh = {"cmd","alt","ctrl"}

function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end


Modal = require("modal")
Notifications = require("notifications")
Wezterm = require("wezterm")

chromeBrowser = appID('/Applications/Google Chrome.app')
braveBrowser = appID('/Applications/Brave Browser.app')
ZoomApp = appID('/Applications/zoom.us.app')

Wezterm.start()
Notifications.start()

Modal:init({
  open_mode = {
    {
      title = '== Open / Launch application ==',
      keys = {
        a='Calendar',
        b='Brave Browser',
        c='Visual Studio Code',
        e='Finder',
        g='Google Chrome',
        h='Google Chrome Canary',
        i='IntelliJ IDEA CE',
        l='LINE',
        m='Spark',
        o='Obsidian',
        s='Slack',
        t='Telegram',
        w='WezTerm',
        y='Youtube Music',
        z='zoom.us',
      }
    },
    {
      title = "== Create new instance ==",
      entriesPerLine = 3,
      modifiers = {shift = true},
      keys = {
        b='Brave Browser',
        c='Visual Studio Code',
        g='Google Chrome',
        h='Google Chrome Canary',
        i='IntelliJ IDEA CE',
        w='WezTerm',
      }
    },
  },
  resize_mode = {
    {
      title = '== Increase window size ==',
      entriesPerLine = 4,
      keys = {
        j='Left',
        k='Bottom',
        i='Top',
        l='Right',
      }
    },
    {
      title = '== Decrease window size ==',
      modifiers = {shift = true},
      entriesPerLine = 4,
      keys = {
        j='Left',
        k='Bottom',
        i='Top',
        l='Right',
      }
    },
    {
      title = '== Move window size ==',
      modifiers = {alt = true},
      entriesPerLine = 4,
      keys = {
        j='Left',
        k='Bottom',
        i='Top',
        l='Right',
      }
    },
  },
  config_mode = {
    {
      title = '== General ==',
      keys = {
        r='Reload Yabai',
        h='Reload Hammerspoon'
      }
    },
    {
      title = '== Spaces ==',
      keys = {
        n='Create space',
        x='Destroy space'
      }
    },
    {
      title = '== Insertion point ==',
      keys = {
        j='Left',
        k='Bottom',
        i='Top',
        l='Right',
        [',']='Stack',
      }
    },
    {
      title = '== Warp a winto to ==',
      modifiers = {alt = true, shift=true},
      keys = {
        j='Left',
        k='Bottom',
        i='Top',
        l='Right',
      }
    },
  },
  leader_mode = {
    {
      title = '== Go to ==',
      keys = {
        o='Open Mode',
        r='Resize Mode',
        c='Config Mode'
      }
    },
  }
})

defaultBrowser = chromeBrowser
personalBrowser = braveBrowser

hs.loadSpoon("URLDispatcher")

spoon.URLDispatcher.url_patterns = {
  { "https?://.*zoom.us/[a-z]/.*/?", ZoomApp },
}

spoon.URLDispatcher.default_handler = defaultBrowser

spoon.URLDispatcher.perAppConfig = {
  Telegram = {default_handler = personalBrowser},
  LINE = {default_handler = personalBrowser},
}

spoon.URLDispatcher:start()

hs.loadSpoon('jira-issues')
spoon['jira-issues']:setup({
    jira_host = '',
    login = '',
    api_token = '',
})
spoon['jira-issues']:start()

-- TODO: Move SlackRebind into a module

slackRebind = hs.hotkey.modal.new()

local function linkSlack()
  hs.eventtap.keyStroke({'cmd', 'shift'}, 'u', 0)
end

local function forwardHistory()
  hs.eventtap.keyStroke({'cmd'}, ']',0)
end

local function backHistory()
  hs.eventtap.keyStroke({'cmd'}, '[',0)
end

local function showHideSideBar()
  hs.eventtap.keyStroke({'shift', 'cmd'}, 'd',0)
end

local function globalSearch()
  hs.eventtap.keyStroke({'cmd'}, 'g',0)
end

local function jumpToConversation()
  hs.eventtap.keyStroke({'cmd'}, 't',0)
end

local function setStatus()
  hs.eventtap.keyStroke({'shift','cmd'}, 'y',0)
end

slackRebind:bind({'cmd'}, 'k', nil, linkSlack, nil, linkSlack)
slackRebind:bind({'ctrl'}, 'pagedown', nil, forwardHistory, nil, forwardHistory)
slackRebind:bind({'ctrl'}, 'pageup', nil, backHistory, nil, backHistory)
slackRebind:bind({'cmd'}, 'p', nil, globalSearch, nil, globalSearch)
slackRebind:bind({'shift','cmd'}, 'p', nil, jumpToConversation, nil, jumpToConversation)
slackRebind:bind({'cmd'}, 'm', nil, showHideSideBar, nil, showHideSideBar)
slackRebind:bind({'cmd'}, 's', nil, setStatus, nil, setStatus)

slackWatcher = hs.application.watcher.new(function(applicationName, eventType)
  if applicationName ~= "Slack" then return end

  if eventType == hs.application.watcher.activated then
    slackRebind:enter()
  elseif eventType == hs.application.watcher.deactivated then
    slackRebind:exit()
  end
end)

slackWatcher:start()