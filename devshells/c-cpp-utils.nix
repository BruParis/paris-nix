{ pkgs }:

{
  cCppInputs = with pkgs; [
    autoconf
    gnumake
    m4
    gperf
    libGLU
    libGL
    xorg.libXi
    xorg.libXmu
    freeglut
    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr
    binutils
  ];
}
