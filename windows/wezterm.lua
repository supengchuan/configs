local wezterm = require("wezterm")

--local edge_background = "#44475A"
local edge_background = "#222130"
local background = "#282a11"
local foreground = "#F8F8F2"

-- The filled in variant of the < symbol 
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
SOLID_LEFT_ARROW = ""

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
SOLID_RIGHT_ARROW = ""

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is not explicitly set, use the title from the active pane in that tab
	if not title or #title == 0 then
		title = tab_info.active_pane.title
	end

	-- limit title length
	if #title > 27 then
		title = ".." .. string.sub(title, -23)
	end

	-- set tab index number
	if tab_info.is_active then
		title = "  " .. title
	else
		title = tab_info.tab_index + 1 .. "-" .. title
	end
	return title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if tab.is_active then
		background = "#6272A4"
		foreground = "#FFFFFF"
	elseif hover then
		background = "#808e9b"
		foreground = "#FFFFFF"
	else
		background = edge_background
		foreground = "#f3f3f3"
	end

	local edge_foreground = background

	-- cut the title suffix if it's length more 27
	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	-- 如果只有一个 tab 就设定一个特殊的名称
	if tab.tab_index == 0 and #tabs == 1 then
		if not tab.tab_title or #tab.tab_title == 0 then
			title = "supc's Wezterm"
		end
	end

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

local config = {
	-- no gpu config
	-- prefer_egl=true,
	-- Spawn a fish shell in login mode
	default_prog = { "c:/Users/supengchuan/scoop/apps/pwsh/current/pwsh.exe" },
	canonicalize_pasted_newlines = "LineFeed",
	audible_bell = "Disabled",
}

function Merge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				Merge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

function SetFont()
	local M = {
		font_size = 14.5,
		font = wezterm.font_with_fallback({
			{ family = "MesloLGS Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "Cousine Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "FiraCode Nerd Font Mono", weight = 450, italic = false },
			{ family = "Hack Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "DejaVuSansM Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "JetBrains Mono", weight = "Regular", italic = false },
			{ family = "UbuntuMono Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "SauceCodePro Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "CommitMono Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "Monofur Nerd Font Mono", weight = "Regular", italic = false },
			{ family = "LXGW WenKai Screen", weight = "Regular", italic = false },
		}),
		--font_rules = {
		--	{
		--		italic = true,
		--		font = wezterm.font_with_fallback({
		--			{ family = "FiraCode Nerd Font Mono", italic = false },
		--		}),
		--	},
		--},
	}

	return M
end

function SetColorTheme()
	-- code
	local color = ""
	color = "Tokyo Night Moon"
	color = "Dracula"
	color = "Adventure"
	color = "rose-pine"
	color = "Everforest Dark (Gogh)"
	color = "Catppuccin Frappe"
	color = "Catppuccin Mocha"

	return {
		color_scheme = color,
	}
end

function SetTab()
	local M = {
		use_fancy_tab_bar = false,
		enable_tab_bar = true,
		hide_tab_bar_if_only_one_tab = false,
		tab_bar_at_bottom = false,
		tab_max_width = 30,
		colors = {
			tab_bar = {
				-- The color of the strip that goes along the top of the window
				-- (does not apply when fancy tab bar is in use)
				background = edge_background,
				new_tab = {
					bg_color = edge_background,
					fg_color = "#EEEEEE",
				},
			},
		},
	}
	return M
end

function SetWindow()
	-- code
	local M = {
		window_decorations = "INTEGRATED_BUTTONS|RESIZE",
		integrated_title_buttons = { "Maximize", "Close" },
		window_background_opacity = 0.97,
		initial_rows = 30,
		initial_cols = 120,
		window_padding = {
			left = "1cell",
			right = "0.5cell",
			top = "0cell",
			bottom = "0cell",
		},
		adjust_window_size_when_changing_font_size = false,
	}

	return M
end

function SetKeyMap()
	-- code
	local M = {
		keys = {
			{
				key = "+",
				mods = "CTRL|SHIFT",
				action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
			},
			{
				key = "_",
				mods = "CTRL|SHIFT",
				action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
			},
		},
	}

	return M
end

function SetMouseMap()
	-- code
	local M = {
		mouse_bindings = {
			{
				event = { Down = { streak = 1, button = "Right" } },
				mods = "NONE",
				action = wezterm.action.PasteFrom("PrimarySelection"),
			},
		},
	}

	return M
end

config = Merge(config, SetFont())
config = Merge(config, SetWindow())
config = Merge(config, SetTab())
config = Merge(config, SetColorTheme())
config = Merge(config, SetKeyMap())
config = Merge(config, SetMouseMap())

return config
