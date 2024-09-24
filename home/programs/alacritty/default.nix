{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.alacritty;
  tomlFormat = pkgs.formats.toml { };
in {
  options = {
    programs.alacritty = {
      # enable = mkEnableOption "Alacritty";

      package = mkOption {
        type = types.package;
        default = pkgs.alacritty;
        defaultText = literalExpression "pkgs.alacritty";
        description = "The Alacritty package to install.";
      };

      settings = mkOption {
        type = tomlFormat.type;
        default = { };
        description = ''
          Configuration written to
          {file}`$XDG_CONFIG_HOME/alacritty/alacritty.yml` or
          {file}`$XDG_CONFIG_HOME/alacritty/alacritty.toml`
          (the latter being used for alacritty 0.13 and later).
          See <https://github.com/alacritty/alacritty/tree/master#configuration>
          for more info.
        '';
        font = {
          size = 12.0;
          bold = {
            family = "JetBrains Mono Nerd Font";
            style = "Bold";
          };
          bold_italic = {
            family = "JetBrains Mono Nerd Font";
            style = "Bold Italic";
          };
          italic = {
            family = "JetBrains Mono Nerd Font";
            style = "Italic";
          };
          normal = {
            family = "JetBrains Mono Nerd Font";
            style = "Regular";
          };
        };
        
        window = {
          opacity = 0.95;
        };
        
        colors = {
          selection = {
            text = "0x1d1f21";
            background = "0xffffff";
          };
        };
        
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."alacritty/alacritty.toml" = lib.mkIf (cfg.settings != { }) {
      source = (tomlFormat.generate "alacritty.toml" cfg.settings).overrideAttrs
        (finalAttrs: prevAttrs: {
          buildCommand = lib.concatStringsSep "\n" [
            prevAttrs.buildCommand
            # TODO: why is this needed? Is there a better way to retain escape sequences?
            "substituteInPlace $out --replace-quiet '\\\\' '\\'"
          ];
        });
    };
  };
}
