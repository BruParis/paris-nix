{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      TERMINAL = "alacritty";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
