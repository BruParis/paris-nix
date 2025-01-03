{ config, pkgs, lib, ... }:

{
  home.packages = lib.optionals config.programs.alacritty.enable
    [ pkgs.nerd-fonts.liberation ];

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        size = 11.0;
        bold = {
          family = "LiterationMono Nerd Font";
          style = "Bold";
        };
        bold_italic = {
          family = "LiterationMono Nerd Font";
          style = "Bold Italic";
        };
        italic = {
          family = "LiterationMono Nerd Font";
          style = "Italic";
        };
        normal = {
          family = "LiterationMono Nerd Font";
          style = "Regular";
        };
      };

      window = {
        dynamic_padding = false;
        opacity = 0.95;
      };

      colors = {
        primary = {
          background = "#282C34";
          foreground = "#ABB2BF";
        };
      };
    };
  };
}
