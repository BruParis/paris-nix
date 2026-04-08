{ config, pkgs, lib, inputs, ... }:

let
  catppuccin-kitty = inputs.catppuccin-kitty;
  darkThemeFile  = "${catppuccin-kitty}/themes/macchiato.conf";
  lightThemeFile = "${catppuccin-kitty}/themes/latte.conf";
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "LiterationMono Nerd Font";
      size = 9;
    };
    settings = {
      background_opacity = "0.95";
      shell = "${pkgs.zsh}/bin/zsh --login";
      allow_remote_control = "yes";
      enable_audio_bell = "no";
    };
    extraConfig = ''
      include ${config.xdg.configHome}/kitty/current-theme.conf
    '';
  };

  xdg.configFile."kitty/themes/dark.conf".source  = darkThemeFile;
  xdg.configFile."kitty/themes/light.conf".source = lightThemeFile;
  xdg.configFile."kitty/themes/frappe.conf".source  = "${catppuccin-kitty}/themes/frappe.conf";
  xdg.configFile."kitty/themes/mocha.conf".source   = "${catppuccin-kitty}/themes/mocha.conf";

  # Seed current-theme.conf with dark on first activation; never overwrite user's choice.
  home.activation.kittyDefaultTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    theme_file="${config.xdg.configHome}/kitty/current-theme.conf"
    if [ ! -f "$theme_file" ]; then
      $DRY_RUN_CMD install -m 644 "${darkThemeFile}" "$theme_file"
    fi
  '';
}
