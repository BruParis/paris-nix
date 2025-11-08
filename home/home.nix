{
  config,
  pkgs,
  users,
  ...
}:

{
  imports = [
    # hyprland.homeManagerModules.default
    ./programs
  ];

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

  # targets.genericLinux.enable = true; # ENABLE THIS ON NON NIXOS

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    hello
    dconf # needed by gtk
    networkmanagerapplet

    wev # for key bindings

    # wayland notification daemon
    mako
    # ... which depends on
    libnotify

    wl-clipboard
    cliphist

    # wall paper daemon
    # hyprpaper
    swww

    kitty # hyprland default
    alacritty

    zsh
    oh-my-zsh
    zsh-powerlevel10k

    # app launcher
    rofi-wayland

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
    slurp

    zathura

    # for dev
    gnumake
    jdk

    electrum
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
    userName = "BrnPrs";
    userEmail = "parisbruno85@gmail.com";
  };

  programs.direnv.enable = true;

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
    bashrcExtra = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        Hyprland
      fi
    '';
  };

}
