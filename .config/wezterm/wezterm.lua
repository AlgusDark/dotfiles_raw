local wezterm = require 'wezterm';

wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "<< TABLE: " .. name .. " >> "
  end
  window:set_right_status(name or "")
end);

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "[Z] "
  end

  local index = ""
  if #tabs > 1 then
    index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end);

local config = {
  debug_key_events = true,
  
  color_scheme = 'nord',
  
  font = wezterm.font("Fantasque Sans Mono"),
  freetype_load_target = "Light",
  font_size = 20,
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 0.95,
  
  default_cursor_style = 'SteadyBar',
  window_close_confirmation = "NeverPrompt",
  
  enable_csi_u_key_encoding = true,
  
  leader = { key="g", mods="SUPER"},
  keys = {
    { key = "g", mods = "LEADER|SUPER", action={SendKey={key="g", mods="CTRL"}}},
    
    {key="'", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="-", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},

    {key="n", mods="LEADER", action=wezterm.action.SpawnWindow},
    
    {key = "j", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
    {key = "k", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
    {key = "l", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
    {key = ";", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
    {key = "j", mods = "SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Left"}},
    {key = "k", mods = "SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Down"}},
    {key = "l", mods = "SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Up"}},
    {key = ":", mods = "SUPER|SHIFT", action=wezterm.action{ActivatePaneDirection="Right"}},

    {key = "f", mods="LEADER", action="ToggleFullScreen" },
    {key = "d", mods="LEADER", action="ActivateCopyMode" },
    {key = "s", mods="LEADER", action="QuickSelect" },
    {key = "a", mods="LEADER", action="TogglePaneZoomState" },
    {key = "f", mods="SUPER|SHIFT", action="ToggleFullScreen" },
    {key = "d", mods="SUPER|SHIFT", action="ActivateCopyMode" },
    {key = "s", mods="SUPER|SHIFT", action="QuickSelect" },
    {key = "a", mods="SUPER|SHIFT", action="TogglePaneZoomState" },

    -- {key="k", mods="SUPER", action=wezterm.action{ClearScrollback="ScrollbackAndViewport"}},
    {key="w", mods="SUPER", action=wezterm.action{CloseCurrentPane={confirm=true}}},
    {key="w", mods ="LEADER", action=wezterm.action{CloseCurrentPane={confirm=true}}},
    {key="f", mods="SUPER", action=wezterm.action{Search={Regex=""}}},
    {key="p", mods="SUPER", action="QuickSelect"},
    {key="p", mods="LEADER", action="QuickSelect"},

    {key="LeftArrow", mods="ALT", action={SendKey={key="b", mods="ALT"}}},
    {key="RightArrow", mods="ALT", action={SendKey={key="f", mods="ALT"}}},

    {key="r", mods="LEADER", action=wezterm.action{
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

      -- Cancel the mode by pressing escape
      {key="Escape", action="PopKeyTable"},

    },
  }
}

-- local alphabet = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPRSTUVWXYZ[\\]^_`abcdefghijklmnoprstuvwxyz{|}~" 
-- local length = #alphabet
-- local keys = {}
-- for i = 1,length do  
--   local char = string.sub(alphabet, i, i) 
--   table.insert(keys, {key = char, mods= "SUPER", action={SendKey={key=char, mods="CTRL"}}})
--   table.insert(keys, {key = char, mods= "SHIFT|SUPER", action={SendKey={key=char, mods="SHIFT|CTRL"}}})
-- end

-- for k,v in pairs(keys)
-- do
--   table.insert(config.keys, v);
-- end

-- table.insert(config.keys, table.unpack(keys))

return config