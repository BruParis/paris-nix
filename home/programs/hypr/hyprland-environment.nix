{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      TERMINAL = "alacritty";
      CLUTTER_BACKEND = "wayland";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
