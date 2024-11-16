# hyprland.nix

{ pkgs, lib, config, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

    sleep 1

    ${pkgs.swww}/bin/swww img ${./empty.png} &

    # installed with pkgs.networkmanagerapplet
    nm-applet --indicator &

    # wayland bar
    waybar &

    # notification daemon
    mako
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = "${startupScript}/bin/start";
      input.kb_layout = "fr";
    };

  };

  home.file.".config/hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
}

