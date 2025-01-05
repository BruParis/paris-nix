{
  config,
  lib,
  pkgs,
  ...
}:

let
  hyprlandConfig = builtins.readFile ./hyprland.config;
  hyprlandColors = builtins.readFile ./colors.txt;
in
{
  imports = [ ./hyprland-environment.nix ];

  home.packages = with pkgs; [
    waybar
    swww
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = hyprlandConfig;
  };

  home.file.".config/hypr/colors".text = hyprlandColors;
  home.file.".config/hypr/images".source = ../../wallpapers;
}
