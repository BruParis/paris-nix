# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "paris-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.consoleKeyMap = "fr-latin1";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "fr-latin1";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };  

  # Configure keymap in X11
  services.xserver.xkb.layout = "fr";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  security.rtkit.enable = true;
  # with pipewire
  services.pipewire = {
    enable = true;
    alsa.enable =true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # Not needed if pipewire
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    hashedPassword = "$6$f7/tk7gvCV.7j7P9$NclQwH5VffccfUbJq/Vouo1AdO1GroozzwK5rhAzgG6fP61t8EY.SWqq6xVT/dF7zLKzPP.3CK7Lftq8snar7/";
  };
  users.users.bruno = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$ZBXl1qCQMq7iYa5h$6np0VTJpl8vpop2kHVptX8wBILURSFwuZPfY3BGzY0Q7y0CzbciVYj7idmeT3ste.c72LtA/5F4c545dP1CfE1";
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tmux

    # wayland notification daemon
    mako
    # ... which depends on:
    libnotify

    # wall paper daemon
    # hyprpaper
    swww

    kitty # hyprland default
    alacritty

    # app launcher
    rofi-wayland

    # exa
    eza
  ];

  programs.hyprland.enable = true; 
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # Desktop portals: handles desktop programs interactions, screen-sharing, file opening
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.dbus.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

