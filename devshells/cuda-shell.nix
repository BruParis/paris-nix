{ pkgs, sharedInputs }:

let
  auxInputs = with pkgs; [
    git
    gitRepo
    gnupg
    autoconf
    curl
    procps
    gnumake
    util-linux
    m4
    gperf
    unzip
    cudatoolkit
    cudaPackages.cuda_cudart
    linuxPackages.nvidia_x11
    libGLU
    libGL
    xorg.libXi
    xorg.libXmu
    freeglut
    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr
    zlib
    ncurses5
    stdenv.cc
    binutils
  ];
in pkgs.mkShell {
  name = "cuda";
  buildInputs = sharedInputs.sharedPkgs ++ auxInputs;
  shellHook = ''
    figlet -f slant "CUDA-ENV"
  '';

  CUDA_PATH = "${pkgs.cudatoolkit}";
  LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}:$LD_LIBRARY_PATH";
  EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
  EXTRA_CCFLAGS = "-I/usr/include";
}
