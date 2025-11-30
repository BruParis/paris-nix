{
  config,
  pkgs,
  lib,
  ...
}:

{

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
      setw -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
