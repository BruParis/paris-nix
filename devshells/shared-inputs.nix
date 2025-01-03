{ pkgs }:

{
  sharedPkgs = with pkgs; [
    figlet
    git
    gitRepo
    gnupg
    curl
    procps
    util-linux
    unzip
    zlib
    ncurses5
  ];

  sharedEnv = {
  };
}

