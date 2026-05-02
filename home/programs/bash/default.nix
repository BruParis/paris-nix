{ config, pkgs, lib, isNixOS ? true, ... }:

let customBashrc = builtins.readFile ./bashrc.txt;
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # On non-NixOS, /etc/profile.d/ is not sourced for interactive shells,
    # so nix-env and other nix tools are missing from PATH.
    bashrcExtra = customBashrc + lib.optionalString (!isNixOS) ''
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    '';
  };
}
