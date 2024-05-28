{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local theme = "Dracula (Official)"
      local scheme = wezterm.color.get_builtin_schemes()[theme]
      scheme.background = "#101116"

      return {
        hide_tab_bar_if_only_one_tab = true,
        font = wezterm.font_with_fallback({
          "Fira Code Nerd Font",
          "Twemoji",
          "Twitter Color Emoji",
          "Symbols Nerd Font",
        }),
        front_end = "WebGpu",
        visual_bell = {
          fade_in_duration_ms = 75,
          fade_out_duration_ms = 75,
          target = "CursorColor",
        },
        audible_bell = "Disabled",
        font_size = 10.0,
        color_schemes = {
          [theme] = scheme,
        },
        color_scheme = theme,
        window_background_opacity = 0.8,
        keys = { {
          mods = "CTRL|SHIFT",
          key = "Enter",
          action = wezterm.action.SpawnWindow,
        } },
      }
    '';
  };
}
