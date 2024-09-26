{ config, pkgs, lib, ... }:

let
  customBashrc = builtins.readFile ./bashrc.txt;
in
{
  # Enable bash with home-manager
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # shellInit = oldBashrc;  # Source the bashrc.txt file
    bashrcExtra = customBashrc;
  };
}
