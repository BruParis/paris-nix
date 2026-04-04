{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # spell
    aspell
    aspellDicts.en

    # fonts
    nerd-fonts.symbols-only

    # lookup
    ripgrep
    fd

    # formatters (format +onsave)
    shfmt                 # sh
    nodePackages.prettier # mainly for yaml
  ];

  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
    emacs = pkgs.emacs-pgtk;
  };
}
