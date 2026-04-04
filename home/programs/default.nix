{ lib, withHyprland ? true, ... }:
{
  imports = [
    ./alacritty
    ./zsh
    ./tmux
    ./nix-doom-emacs-unstraightened
  ] ++ lib.optionals withHyprland [
    ./hypr
    ./waybar
  ];
}
