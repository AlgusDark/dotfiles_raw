local wezterm = require 'wezterm';
local act = wezterm.action
-- wezterm.target_triple == "x86_64-pc-windows-msvc" | x86_64-apple-darwin | x86_64-unknown-linux-gnu

local function strip_home_name(text)
  local username = os.getenv("USER")
  local clean_text = text:gsub("/Users/" .. username, "~")
  return clean_text
end

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	local clean_title = tab.active_pane.title

	return zoomed .. index .. clean_title
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = ''
  local foreground = ''

  if tab.is_active then
		background = '#86C0D1'
		foreground = '3B4253'
	else
		background =  '#4C566B'
		foreground = '#E5E9F0'
	end

  local title = string.match(strip_home_name(tab.active_pane.title), "[^/]+$")
  title = string.match(title, "[^ - ]+$")
  if #title >= 22 then
    title = wezterm.truncate_right(title, max_width-3) .. utf8.char(0x2026)
  end

  local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

  if tab.tab_index == 0 then
    return {
      {Foreground={Color=foreground}},
      {Background={Color=background}},
      { Text = ' ' .. tab.tab_index + 1 },
      {Text = '❭'},
      {Foreground={Color=foreground}},
      {Background={Color=background}},
      { Text = title .. ' ' },
      {Foreground={Color=background}},
      {Background={Color='#2E3440'}},
      { Text = SOLID_RIGHT_ARROW},
    }
  else
    return {
      {Foreground={Color='#2E3440'}},
      {Background={Color=background}},
      { Text = SOLID_RIGHT_ARROW },
      {Foreground={Color=foreground}},
      {Background={Color=background}},
      { Text = ' ' .. tab.tab_index + 1 },
      {Text = '❭'},
      {Foreground={Color=foreground}},
      {Background={Color=background}},
      { Text = title  .. ' ' },
      {Foreground={Color=background}},
      {Background={Color='#2E3440'}},
      { Text = SOLID_RIGHT_ARROW},
    }
  end
  
end)

wezterm.on("update-right-status", function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {};

  local key_table = window:active_key_table()
  if key_table == 'resize_pane' then
    table.insert(cells, '(ノಠ益ಠ)ノ彡┻━┻')
  else
    table.insert(cells, '')
  end

  local date = wezterm.strftime(wezterm.nerdfonts.linux_apple .. " %a %b %-d %H:%M");
  table.insert(cells, date);

  for _, b in ipairs(wezterm.battery_info()) do
    local charge = b.state_of_charge * 100

    if charge >= 0 and charge <= 10 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_10 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 11 and charge <= 20 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_20 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 21 and charge <= 30 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_30 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 31 and charge <= 40 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_40 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 41 and charge <= 50 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_30 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 51 and charge <= 60 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_50 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 61 and charge <= 70 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_60 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 71 and charge <= 80 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_70 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 81 and charge <= 90 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_80 .. ' ' .. "%.0f%%", charge))
    elseif charge >= 91 and charge <= 95 then
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery_90 .. ' ' .. "%.0f%%", charge))
    else 
      table.insert(cells, string.format(wezterm.nerdfonts.mdi_battery .. ' ' .. "%.0f%%", charge))
    end

  end

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3);
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local colors = {
    "#2E3440",
    "#3B4253",
    "#434C5F",
    "#4C566B",
  };

  local text_fg = {
    "#D8DEE9",
    "#E5E9F0",
    "#ECEFF4",
    '#8EBCBB',
  };

  -- The elements to be formatted
  local elements = {};
  -- How many cells have been formatted
  local num_cells = 0;

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, {Foreground={Color=text_fg[cell_no]}})
    table.insert(elements, {Background={Color=colors[cell_no]}})
    table.insert(elements, {Text=" "..text.." "})
    if not is_last then
      table.insert(elements, {Foreground={Color=colors[cell_no+1]}})
      table.insert(elements, {Text=SOLID_LEFT_ARROW})
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements));
end)

local config = {
  exit_behavior = "Hold",
  debug_key_events = true,

  -- Nord colors
  colors = {
    foreground = "#d8dee9",
    background = "#2e3440",
    cursor_bg = "#d8dde8",
    cursor_border = "#eceff4",
    cursor_fg = "#3b4151",
    selection_bg = "#4c5569",
    selection_fg = "#d8dde8",
    split= '#434C5F',
    ansi = {
      "#3b4252",
      "#bf616a",
      "#a3be8c",
      "#ebcb8b",
      "#81a1c1",
      "#b48ead",
      "#88c0d0",
      "#e5e9f0"
    },
    brights = {
      "#4c566a",
      "#bf616a",
      "#a3be8c",
      "#ebcb8b",
      "#81a1c1",
      "#b48ead",
      "#8fbcbb",
      "#eceff4"
    },
		tab_bar = {
			background = "#2E3440",
			new_tab = {
				bg_color = "#2E3440",
				fg_color = "#2E3440",
			},
      new_tab_hover = {
        bg_color = "#2E3440",
        fg_color = "#2E3440",
        italic = true,
      },
      active_tab = {
        bg_color = "#4c5569",
        fg_color = "#d8dde8",
        underline = 'None',
        intensity = "Bold",
      },
      inactive_tab = {
        intensity = 'Normal',
        bg_color = '#2E3440',
        fg_color = "#5A697A",
      },
      inactive_tab_hover = {
        bg_color = "#3B4253",
        fg_color = "#D8DEE9",
        italic = false,
      },
		},
	},

  font = wezterm.font("JetBrainsMono Nerd Font",
  {weight="Regular", stretch="Normal", style="Normal"}
  ),

  freetype_load_target = "Light",
  font_size = 18,

  use_fancy_tab_bar = false,

  default_cursor_style = 'SteadyBar',
  window_close_confirmation = "NeverPrompt",

  enable_csi_u_key_encoding = true,
  tab_max_width = 60,

  leader = { key="g", mods="CTRL"},

  adjust_window_size_when_changing_font_size = false,
  keys = {
    { key = "g", mods = "LEADER|SUPER", action={SendKey={key="g", mods="CTRL"}}},

    {key="c", mods="LEADER", action=act{CopyTo="Clipboard"}},
    {key="y", mods="LEADER", action=act{CopyTo="Clipboard"}},
    {key="v", mods="LEADER", action=act{PasteFrom="Clipboard"}},
    {key="Enter", mods="LEADER", action="ToggleFullScreen"},
    {key="R", mods="LEADER", action=act.ReloadConfiguration},

    {key="t", mods="LEADER", action={SpawnTab="CurrentPaneDomain"}},
    {key="T", mods="LEADER", action={SpawnTab="DefaultDomain"}},
    {key="n", mods="LEADER", action='SpawnWindow'},
    {key="W", mods="LEADER", action=act{CloseCurrentTab={confirm=true}}},
    {key="'", mods="LEADER", action=act{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="-", mods="LEADER", action=act{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="w", mods="LEADER", action=act{CloseCurrentPane={confirm=false}}},

    {key = "j", mods = "LEADER", action=act{ActivatePaneDirection="Left"}},
    {key = "k", mods = "LEADER", action=act{ActivatePaneDirection="Down"}},
    {key = "i", mods = "LEADER", action=act{ActivatePaneDirection="Up"}},
    {key = "l", mods = "LEADER", action=act{ActivatePaneDirection="Right"}},

    {key = "x", mods="LEADER", action="ActivateCopyMode" },
    {key = "s", mods="LEADER", action="QuickSelect" },
    {key = "z", mods="LEADER", action="TogglePaneZoomState" },
    {key = "f", mods="LEADER", action=act{Search={Regex=""}}},

    {key="l", mods="CTRL", action=act{ClearScrollback="ScrollbackAndViewport"}},
    {key="k", mods="SUPER", action=act{ClearScrollback="ScrollbackAndViewport"}},

    {key="LeftArrow", mods="ALT", action={SendKey={key="j", mods="CTRL"}}},
    {key="RightArrow", mods="ALT", action={SendKey={key="l", mods="CTRL"}}},

    {key = 'e', mods= "SUPER", action={SendKey={key='e', mods="CTRL"}}},
    {key = 'd', mods= "SUPER", action={SendKey={key='d', mods="CTRL"}}},
    {key = '.', mods= "SUPER", action={SendKey={key='c', mods="CTRL"}}},
    {key = 'j', mods= "SUPER", action={SendKey={key='j', mods="CTRL"}}},
    {key = 'l', mods= "SUPER", action={SendKey={key='l', mods="CTRL"}}},
    {key = 'u', mods= "SUPER", action={SendKey={key='u', mods="CTRL"}}},
    {key = 'o', mods= "SUPER", action={SendKey={key='o', mods="CTRL"}}},
    {key = 'h', mods= "SUPER", action={SendKey={key='h', mods="CTRL"}}},
    {key = 'y', mods= "SUPER", action={SendKey={key='y', mods="CTRL"}}},
    {key = 'i', mods= "SUPER", action={SendKey={key='i', mods="CTRL"}}},
    {key = 'm', mods= "SUPER", action={SendKey={key='m', mods="CTRL"}}},
    {key = ',', mods= "SUPER", action={SendKey={key=',', mods="CTRL"}}},
    {key = 'z', mods= "SUPER", action={SendKey={key='z', mods="CTRL"}}},

    {key="r", mods="LEADER", action=act{
      ActivateKeyTable={
        name="resize_pane",
        one_shot=false,
        replace_current=true,
      }
    }},
  },

  key_tables = {
    resize_pane = {
      {key="LeftArrow", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
      {key="j", action=wezterm.action{AdjustPaneSize={"Left", 5}}},

      {key="DownArrow", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
      {key="k", action=wezterm.action{AdjustPaneSize={"Down", 5}}},

      {key="UpArrow", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
      {key="i", action=wezterm.action{AdjustPaneSize={"Up", 5}}},

      {key="RightArrow", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
      {key="l", action=wezterm.action{AdjustPaneSize={"Right", 5}}},

      {key="Escape", action="PopKeyTable"},

    },
    copy_mode = {
      {key="c", mods="CTRL", action=act.CopyMode("Close")},
      {key="g", mods="CTRL", action=act.CopyMode("Close")},
      {key="q", mods="NONE", action=act.CopyMode("Close")},
      {key="Escape", mods="NONE", action=act.CopyMode("Close")},

      {key="j", mods="NONE", action=act.CopyMode("MoveLeft")},
      {key="k", mods="NONE", action=act.CopyMode("MoveDown")},
      {key="i", mods="NONE", action=act.CopyMode("MoveUp")},
      {key="l", mods="NONE", action=act.CopyMode("MoveRight")},

      {key="LeftArrow",  mods="NONE", action=act.CopyMode("MoveLeft")},
      {key="DownArrow",  mods="NONE", action=act.CopyMode("MoveDown")},
      {key="UpArrow",    mods="NONE", action=act.CopyMode("MoveUp")},
      {key="RightArrow", mods="NONE", action=act.CopyMode("MoveRight")},

      {key="RightArrow", mods="ALT",  action=act.CopyMode("MoveForwardWord")},
      {key="f",          mods="ALT",  action=act.CopyMode("MoveForwardWord")},
      {key="Tab",        mods="NONE", action=act.CopyMode("MoveForwardWord")},
      {key="w",          mods="NONE", action=act.CopyMode("MoveForwardWord")},

      {key="LeftArrow", mods="ALT",   action=act.CopyMode("MoveBackwardWord")},
      {key="b",         mods="ALT",   action=act.CopyMode("MoveBackwardWord")},
      {key="Tab",       mods="SHIFT", action=act.CopyMode("MoveBackwardWord")},
      {key="b",         mods="NONE",  action=act.CopyMode("MoveBackwardWord")},

      {key="0",     mods="NONE",  action=act.CopyMode("MoveToStartOfLine")},
      {key="Enter", mods="NONE",  action=act.CopyMode("MoveToStartOfNextLine")},

      {key="$",     mods="NONE",  action=act.CopyMode("MoveToEndOfLineContent")},
      {key="$",     mods="SHIFT", action=act.CopyMode("MoveToEndOfLineContent")},
      {key="^",     mods="NONE",  action=act.CopyMode("MoveToStartOfLineContent")},
      {key="^",     mods="SHIFT", action=act.CopyMode("MoveToStartOfLineContent")},
      {key="m",     mods="ALT",   action=act.CopyMode("MoveToStartOfLineContent")},

      {key=" ", mods="NONE",  action=act.CopyMode{SetSelectionMode="Cell"}},
      {key="v", mods="NONE",  action=act.CopyMode{SetSelectionMode="Cell"}},
      {key="V", mods="NONE",  action=act.CopyMode{SetSelectionMode="Line"}},
      {key="V", mods="SHIFT", action=act.CopyMode{SetSelectionMode="Line"}},
      {key="v", mods="CTRL",  action=act.CopyMode{SetSelectionMode="Block"}},

      {key="G", mods="NONE",  action=act.CopyMode("MoveToScrollbackBottom")},
      {key="G", mods="SHIFT", action=act.CopyMode("MoveToScrollbackBottom")},
      {key="g", mods="NONE",  action=act.CopyMode("MoveToScrollbackTop")},

      {key="H", mods="NONE",  action=act.CopyMode("MoveToViewportTop")},
      {key="H", mods="SHIFT", action=act.CopyMode("MoveToViewportTop")},
      {key="M", mods="NONE",  action=act.CopyMode("MoveToViewportMiddle")},
      {key="M", mods="SHIFT", action=act.CopyMode("MoveToViewportMiddle")},
      {key="L", mods="NONE",  action=act.CopyMode("MoveToViewportBottom")},
      {key="L", mods="SHIFT", action=act.CopyMode("MoveToViewportBottom")},

      {key="o", mods="NONE",  action=act.CopyMode("MoveToSelectionOtherEnd")},
      {key="O", mods="NONE",  action=act.CopyMode("MoveToSelectionOtherEndHoriz")},
      {key="O", mods="SHIFT", action=act.CopyMode("MoveToSelectionOtherEndHoriz")},

      {key="PageUp",   mods="NONE", action=act.CopyMode("PageUp")},
      {key="PageDown", mods="NONE", action=act.CopyMode("PageDown")},

      {key="b", mods="CTRL", action=act.CopyMode("PageUp")},
      {key="f", mods="CTRL", action=act.CopyMode("PageDown")},

      {key="u", mods="CTRL", action=act.CopyMode("ClearPattern")},

      -- yank in copy mode
      {key="y", mods="NONE", action=act{CopyTo="Clipboard"}},
      {key="c", mods="NONE", action=act{CopyTo="Clipboard"}},
    },
  },

  search_mode = {
    {key="Escape", mods="NONE", action=act.CopyMode("Close")},
    {key="UpArrow", mods="NONE", action=act.CopyMode("PriorMatch")},
    {key="Enter", mods="NONE", action=act.CopyMode("PriorMatch")},
    {key="p", mods="CTRL", action=act.CopyMode("PriorMatch")},
    {key="PageUp", mods="NONE", action=act.CopyMode("PriorMatchPage")},
    {key="PageDown", mods="NONE", action=act.CopyMode("NextMatchPage")},
    {key="n", mods="CTRL", action=act.CopyMode("NextMatchPage")},
    {key="DownArrow", mods="NONE", action=act.CopyMode("NextMatch")},
    {key="r", mods="CTRL", action=act.CopyMode("CycleMatchType")},
    {key="u", mods="CTRL", action=act.CopyMode("ClearPattern")},
    {key="y", mods="CTRL", action=act{CopyTo="Clipboard"}},
  },

  mouse_bindings = {
    {
      event={Down={streak=1, button="Right"}},
      mods="NONE",
      action=wezterm.action.PasteFrom("PrimarySelection"),
    },
  },
}

return config
