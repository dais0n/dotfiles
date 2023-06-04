local wezterm = require("wezterm")
return {
	font = wezterm.font("FiraMono Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	font_size = 13.0,
	color_scheme = "nord",
	-- Spawn a fish shell in login mode
	default_prog = { "/usr/local/bin/zsh" }
}
