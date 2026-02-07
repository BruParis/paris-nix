{
  config,
  pkgs,
  lib,
  withHyprland ? true,
  isNixOS ? true,
  inputs,
  ...
}:

let
  claude-code = inputs.claude-code.packages.${pkgs.system}.default;
in
{
  imports = [
    ./programs
  ];

  # Pass withHyprland to submodules
  _module.args = { inherit withHyprland; };

  # Enable genericLinux target for non-NixOS systems (e.g., Fedora)
  targets.genericLinux.enable = !isNixOS;

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello
    dconf # needed by gtk
    networkmanagerapplet

    kitty
    alacritty
    tmux

    # sound
    alsa-utils
    pavucontrol

    zsh
    oh-my-zsh
    zsh-powerlevel10k

    # app launcher
    rofi

    # Browsers
    firefox
    google-chrome

    # misc
    xclip
    pamixer
    trash-cli
    zip
    unzip
    feh

    zathura

    # for dev
    gnumake
    jdk

    electrum

    claude-code
  ] ++ lib.optionals withHyprland [
    # Wayland/Hyprland specific packages
    wev # for key bindings
    mako # wayland notification daemon
    libnotify
    wl-clipboard
    cliphist
    swww # wallpaper daemon
    slurp # screen region selector
  ];

  #  Manage environment variables manually by sourcing 'hm-session-vars.sh' at:
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #  /etc/profiles/per-user/bruno/etc/profile.d/hm-session-vars.sh

  home.sessionVariables = {
    EDITOR = "vim";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "BrnPrs";
      email = "parisbruno85@gmail.com";
    };
  };

  # programs.direnv.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/*" = [ "sxiv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Allows home-manager to link files from the nix store right into home directory
    ".icons/bibata".source = "${pkgs.bibata-cursors}/share/icaons/Bibata-Modern-Classic";
    ".scripts".source = ./scripts;
  };

  services.ssh-agent.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = lib.optionalString (withHyprland && isNixOS) ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        Hyprland
      fi
    '';
  };
#   Host bparis-crouser
#     HostName 137.194.54.39
#     User bparis
#     IdentityFile /home/bruno/.ssh/bparis_pro
# Host jean-zay
#     HostName jean-zay.idris.fr
#     User udj59kh
#     ProxyJump bparis-crouser
#     ForwardAgent Yes


  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      github = {
        hostname = "github.com";
        identityFile = "~/.ssh/paris_nix";
      };
      bparis-crouser = {
        user = "bparis";
        hostname = "137.194.54.39";
        identityFile = "~/.ssh/bparis_pro";
      };
      jean-zay = {
        hostname = "jean-zay.idris.fr";
        user = "udj59kh";
        proxyJump = "bparis-crouser";
        forwardAgent = true;
      };
    };
  };

}
