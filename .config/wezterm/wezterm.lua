local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Catppuccin Macchiato"
config.window_background_opacity = 0.9

config.line_height = 1.05
config.font_size = 16
config.font = wezterm.font_with_fallback({
	"Operator Mono Lig Book",
	"JetBrainsMono Nerd Font Mono",
	"Hack Nerd Font",
})

config.keys = {
	{
		key = "j",
		mods = "CMD",
		action = wezterm.action.SendString("\x02\x54 \n"),
	},
}

return config
