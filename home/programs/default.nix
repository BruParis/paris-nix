{ lib, withHyprland ? true, withDoomEmacs ? true, ... }:
{
  imports = [
    ./alacritty
    ./kitty
    ./zsh
    ./tmux
  ] ++ lib.optionals withDoomEmacs [
    ./nix-doom-emacs-unstraightened
  ] ++ lib.optionals withHyprland [
    ./hypr
    ./waybar
  ];
}
