{
  pkgs,
  sharedUtils,
}:
let
 auxInputs = with pkgs; [
    python312
    python312Packages.pip
    python312Packages.virtualenv
    python312Packages.black
    python312Packages.flake8
  ];
in
pkgs.mkShell {
  name = "python312";

  packages = sharedUtils.sharedInputs ++ auxInputs;
  shellHook = ''
    figlet -f slant "Python 3.12"
  '';
}

