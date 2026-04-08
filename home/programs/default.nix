{ lib, withHyprland ? true, ... }:
{
  imports = [
    ./alacritty
    ./kitty
    ./zsh
    ./tmux
    ./nix-doom-emacs-unstraightened
  ] ++ lib.optionals withHyprland [
    ./hypr
    ./waybar
  ];
}
