local wezterm = require("wezterm")

local config = wezterm.config_builder()



--------* UI *--------

config.font = wezterm.font 'FiraCode Nerd Font Ret'
config.font = wezterm.font { family = "FiraCode Nerd Font Ret" }
config.font_size = 13.0
config.freetype_load_flags = "NO_HINTING"

-- Colorscheme
config.colors = {
  visual_bell = "#4c566a",
  cursor_bg = "#bbbbbb",
  cursor_fg = "#000000",
  cursor_border = "#bbbbbb",
  compose_cursor = "#dd4330",
  tab_bar = {
    background = '#000000',
    --tabs
    active_tab = {
      fg_color = "#aaaaaa",
      bg_color = "#393939",
    },
    new_tab_hover = {
      fg_color = "#aaaaaa",
      bg_color = "#393939",
      italic = false,
    },
    inactive_tab = {
      fg_color = "#6d6d6d",
      bg_color = "#202126",
    },
    inactive_tab_hover = {
      fg_color = "#6d6d6d",
      bg_color = "#202126",
      italic = false,
    },
    new_tab = {
      fg_color = "#6d6d6d",
      bg_color = "#202126",
    },
  },
}
local border_width = '0cell'
config.window_frame = {
  border_left_width = border_width,
  border_right_width = border_width,
  border_bottom_height = border_width,
  border_top_height = border_width,
  inactive_titlebar_bg = "#ff0000",
  active_titlebar_border_bottom = "#ff0000",
}
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = "2px",
  bottom = 0,
}
-- local slash = wezterm.nerdfonts.fae_slash
--
-- config.window_frame = {
--   font = wezterm.font { family = "FiraCode Nerd Font Ret" },
--   font_size = 14,
--   active_titlebar_bg = '#FFFFFF',
-- }
-- config.tab_bar_style = {
--   active_tab_right = wezterm.format {
--     { Background = { Color = '#aaaaaa' } },
--     { Foreground = { Color = '#393939' } },
--     { Text = slash },
--   }
--
-- }

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  local tabtitle =  tab_info.active_pane.title
  if tabtitle == "~" then
    tabtitle = " ~ "
  end
  tabtitle = " " .. tabtitle .. " "
  return tabtitle
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local active_background = "#393939"
    local active_foreground = "#aaaaaa"

    local inactive_background = "#202126"
    local inactive_foreground = "#6d6d6d"

    local background = inactive_background
    local foreground = inactive_foreground

    if tab.is_active then
      background = active_background
      foreground = active_foreground
    elseif hover then
      background = inactive_background
      foreground = active_foreground
    end


    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    if tab.tab_id == 0 then
      return {
        { Background = { Color = background } },
        { Foreground = { Color = background } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = inactive_background } },
        { Foreground = { Color = background } },
        { Text = SOLID_RIGHT_ARROW },
      }
    end

    return {
      { Background = { Color = inactive_background } },
      { Foreground = { Color = background } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = inactive_background } },
      { Foreground = { Color = background } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)


-- Tabs
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 20

-- Alert bell
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 100,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 100,
}

--------* Keybindings *--------
config.disable_default_key_bindings = true

config.keys = {
  -- Panes
  {
    key = "Enter",
    mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "Enter",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
  {
    key = "LeftArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize({ "Left", 1 }),
  },
  {
    key = "RightArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize({ "Right", 1 }),
  },
  {
    key = "UpArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize({ "Up", 1 }),
  },
  {
    key = "DownArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.AdjustPaneSize({ "Down", 1 }),
  },
  {
    key = "j",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "z",
    mods = "CTRL|SHIFT",
    action = wezterm.action.TogglePaneZoomState,
  },
  -- Quick Select
  {
    key = "Space",
    mods = "CTRL|SHIFT",
    action = wezterm.action.QuickSelect,
  },
  -- Activate copy mode
  {
    key = "x",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateCopyMode,
  },
  -- Clipboard
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  -- Font size
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "+",
    mods = "CTRL|SHIFT",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action.ResetFontSize,
  },
  -- Tabs
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "t",
    mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },
  {
    key = "Tab",
    mods = "CTRL",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = "Tab",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = "1",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(0),
  },
  {
    key = "2",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = "3",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = "4",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(3),
  },
  {
    key = "5",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(4),
  },
  {
    key = "6",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(5),
  },
  {
    key = "7",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(6),
  },
  {
    key = "8",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(7),
  },
  {
    key = "9",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTab(8),
  },
  -- Window
  {
    key = "n",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SwitchToWorkspace
  },
  -- Search
  {
    key = "f",
    mods = "CTRL|SHIFT",
    action = wezterm.action.Search({ CaseSensitiveString = "" }),
  },
  -- Scrollback
  {
    key = "PageUp",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ScrollByPage(-1),
  },
  {
    key = "PageDown",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ScrollByPage(1),
  },
  {
    key = "Home",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ClearScrollback("ScrollbackOnly"),
  },
  -- Command palette
  {
    key = "p",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = 'r',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.ReloadConfiguration,
  },
}

-- Zen-mode plugin integration in Neovim --
-- wezterm.on("user-var-changed", function(window, pane, name, value)
-- 	local overrides = window:get_config_overrides() or {}
-- 	if name == "ZEN_MODE" then
-- 		local incremental = value:find("+")
-- 		local number_value = tonumber(value)
-- 		if incremental ~= nil then
-- 			while number_value > 0 do
-- 				window:perform_action(wezterm.action.IncreaseFontSize, pane)
-- 				number_value = number_value - 1
-- 			end
-- 			overrides.enable_tab_bar = false
-- 		elseif number_value < 0 then
-- 			window:perform_action(wezterm.action.ResetFontSize, pane)
-- 			overrides.font_size = nil
-- 			overrides.enable_tab_bar = true
-- 		else
-- 			overrides.font_size = number_value
-- 			overrides.enable_tab_bar = false
-- 		end
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)


return config
