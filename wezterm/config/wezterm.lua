local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.font = wezterm.font "Fira Mono Nerd Font"
config.font_size = 10.0

config.window_frame = {
    font_size = 10.0,
}

config.color_scheme = "Tokyo Night Storm"

config.initial_cols = 100
config.initial_rows = 30

return config
