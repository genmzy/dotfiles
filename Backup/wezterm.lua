local wezterm = require "wezterm"

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	ssh_cmd = { "powershell.exe", "ssh" }
	table.insert(
		launch_menu,
		{
			label = "NyaGOS",
			args = { "nyagos.exe", "--glob" },
		}
	)
end

local ssh_config_file = wezterm.home_dir .. "/.ssh/config"
local f = io.open(ssh_config_file)
if f then
	local line = f:read("*l")
	while line do
		if line:find("Host ") == 1 then
			local host = line:gsub("Host ", "")
			table.insert(
				launch_menu,
				{
					label = "SSH " .. host,
					args = { "ssh", host }
				}
			)
		end
		line = f:read("*l")
	end
	f:close()
end

local mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action { PasteFrom = "Clipboard" }
	},
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action { CompleteSelection = "PrimarySelection" }
	},
	-- and make CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = "OpenLinkAtMouseCursor"
	}

}

--[[
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title_with_icon
	local title = " " .. wezterm.truncate_right(title_with_icon, max_width - 6) .. " "

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Text = title },
		{ Attribute = { Intensity = "Normal" } },
	}
end)
]]

wezterm.on(
	"update-right-status",
	function(window)
		local date = wezterm.strftime("%Y-%m-%d %H:%M:%S ")
		window:set_right_status(
			wezterm.format(
				{
					{ Text = date }
				}
			)
		)
	end
)

return {
	set_environment_variables = {
		PATH = wezterm.executable_dir .. ";" .. os.getenv("PATH"),
	},
	window_background_opacity = 0.9,
	launch_menu = launch_menu,
	mouse_bindings = mouse_bindings,
	disable_default_key_bindings = false,
	default_prog = { "wsl.exe", "--cd", "~" },
	-- font = wezterm.font("Ligamononoki NF"),
	-- font = wezterm.font("JetBrainsMono NF"),
	-- font = wezterm.font("RecMonoGenmzyUnsimple NF"),
	-- font = wezterm.font("RecMonoLinear NF"),
	font = wezterm.font("RecMonoDuotone NF"),
	text_background_opacity = 1.0,
	-- color_scheme = "Gruvbox Dark",
	colors = {
		tab_bar = {
			inactive_tab_edge = "#575757",
			active_tab = {
				bg_color = "#57454A",
				fg_color = "#c0c0c0",
				strikethrough = false,
			},
			-- background = "#0b0022"
		},
		selection_bg = "#3C3836",
		cursor_bg = "#5C6A72",
		cursor_fg = "black",
		ansi = { "#32302F", "#CC241D", "#B8BB26", "#D79921", "#83A598", "#B16286", "#689D6A", "#928374" },
		brights = { "#665C54", "#FB4934", "#B8BB26", "#FABD2F", "#83A598", "#D3869B", "#8EC07C", "#F2E5BC" },
		background = "#1E1E1E",
		foreground = "#F2E5BC",
		scrollbar_thumb = "#57454A"
	},
	font_size = 9.0,
	-- use_fancy_tab_bar = true,
	window_frame = {
		font = wezterm.font({ family="JetBrainsMono NF" }),
		font_size = 8,
		active_titlebar_bg = "#333333",
		inactive_titlebar_bg = "#333333",
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	enable_scroll_bar = true
}
