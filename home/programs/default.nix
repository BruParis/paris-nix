{ lib, withHyprland ? true, ... }:
{
  imports = [
    ./alacritty
    ./zsh
    ./tmux
  ] ++ lib.optionals withHyprland [
    ./hypr
    ./waybar
  ];
}
