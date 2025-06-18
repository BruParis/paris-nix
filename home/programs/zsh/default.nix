{
  config,
  pkgs,
  lib,
  ...
}:

{

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "exa -l --group-directories-first";
      la = "exa -la --group-directories-first";
      l = "exa --group-directories-first";
      tree = "tree -C";
      # grep = "rg";

      # Safety aliases
      rm = "echo 'rm disabled. Use trash-cli instead.'";
      mv = "mv -i";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-custom";
        file = "p10k.zsh";
        src = ./p10k-config;
      }
    ];
    autocd = true;
    # initExtra = ''
    #   [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && Hyprland
    # '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        # "zsh-autosuggestions"
        # "zsh-syntax-highlighting"
        # "zsh-completions"
      ];
      custom = "$HOME/.oh-my-zsh/custom/";
    };
  };

}
