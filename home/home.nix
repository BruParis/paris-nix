{
  config,
  pkgs,
  lib,
  withHyprland ? true,
  withDoomEmacs ? true,
  isNixOS ? true,
  homeUsername ? "bruno",
  # On non-NixOS hosts (e.g. Fedora) Nix can't find the system OpenGL drivers.
  # The caller injects a wrapGL function (via flake.nix extraSpecialArgs) that
  # prepends nixGL to the launch command so the host EGL/Mesa is found at runtime.
  # Defaults to identity so NixOS and generic Linux configs share this file.
  wrapGL ? (bin: pkg: pkg),
  inputs,
  ...
}:

let
  claude-code = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
  nvim = inputs.paris-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim;
in
{
  imports = [
    ./programs
  ];

  # Pass withHyprland to submodules
  _module.args = { inherit withHyprland withDoomEmacs isNixOS wrapGL; };

  # Enable genericLinux target for non-NixOS systems (e.g., Fedora)
  targets.genericLinux.enable = !isNixOS;

  home.username = homeUsername;
  home.homeDirectory = "/home/${homeUsername}";

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
    nvim
  ] ++ lib.optionals withHyprland [
    # Wayland/Hyprland specific packages
    wev # for key bindings
    mako # wayland notification daemon
    libnotify
    wl-clipboard
    cliphist
    swww # wallpaper daemon
    slurp # screen region selector
    grim # screenshot tool
  ];

  #  Manage environment variables manually by sourcing 'hm-session-vars.sh' at:
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #  /etc/profiles/per-user/bruno/etc/profile.d/hm-session-vars.sh

  home.sessionVariables = {
    EDITOR = "vim";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  # Override the package that home-manager installs so only one binary lands in
  # the profile. On NixOS wrapGL is the identity, so this is a no-op there.
  programs.kitty.package = wrapGL "kitty" pkgs.kitty;
  programs.alacritty.package = wrapGL "alacritty" pkgs.alacritty;

  programs.git = {
    enable = true;
    signing.format = null;
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

  home.file = {
    # Allows home-manager to link files from the nix store right into home directory
    ".icons/bibata".source = "${pkgs.bibata-cursors}/share/icaons/Bibata-Modern-Classic";
    ".scripts".source = ./scripts;
    "Pictures/Screenshots/.keep".text = "";

    # nix-doom-emacs-unstraightened bypasses straight.el entirely, so the
    # straight/build-* directory that Doom's doctor expects never gets created.
    # This dummy file forces home-manager to create the directory on every
    # activation, silencing the "File is missing" error from `doom doctor`.
    # At each Emacs version changes (e.g. build-30.3),
    # update the path below to match.
    ".local/share/nix-doom/straight/build-30.2/.keep".text = "";
  };

  services.ssh-agent.enable = true;


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
        identityFile = "~/.secrets/bru_perso2";
      };
      bparis-crouser = {
        user = "bparis";
        hostname = "137.194.54.39";
        identityFile = "~/.secrets/bparis_pro";
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
