{
  config,
  lib,
  pkgs,
  isNixOS ? true,
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
    # On NixOS: install the package from nixpkgs.
    # On Fedora: set package = null so home-manager manages only the config
    # while the system (dnf) binary is used.
    package = if isNixOS then pkgs.hyprland else null;
    systemd.enable = true;
    extraConfig = hyprlandConfig;
  };

  xdg.portal.config.common.default = "*";

  home.file.".config/hypr/colors".text = hyprlandColors;
  home.file.".config/hypr/images".source = ../../wallpapers;
}
