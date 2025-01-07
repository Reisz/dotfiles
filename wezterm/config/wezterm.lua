local wezterm = require "wezterm"

local ok, fontSize = pcall(require, "font-size")
if not ok then
    fontSize = 10.0
end

local config = wezterm.config_builder()


config.font = wezterm.font "Fira Mono Nerd Font"
config.font_size = fontSize

config.window_frame = {
    font_size = fontSize,
}

config.color_scheme = "Tokyo Night Storm"

config.initial_cols = 100
config.initial_rows = 30

return config
