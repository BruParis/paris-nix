{
  config,
  pkgs,
  lib,
  ...
}:

{

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    escapeTime = 10; # default 500ms delays Esc and breaks Alt (<M-...>) keys in nvim
    focusEvents = true; # lets nvim know when it gains/loses focus
    terminal = "tmux-256color";

    extraConfig = ''

      # Enable true color (24-bit) for the outer terminal
      set -as terminal-features ",xterm*:RGB"

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # Custom keybindings for panel navigation
      bind-key -r -T prefix h select-pane -L
      bind-key -r -T prefix j select-pane -D
      bind-key -r -T prefix k select-pane -U
      bind-key -r -T prefix l select-pane -R
    '';
  };
}
