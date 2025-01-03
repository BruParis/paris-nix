{
  pkgs,
  cCppInputs,
  sharedInputs,
}:

let
  auxInputs = with pkgs; [
    cudatoolkit
    cudaPackages.cuda_cudart
    cudaPackages_11.libcufft
    linuxPackages.nvidia_x11
  ];
in
pkgs.mkShell {
  name = "cuda";
  buildInputs = cCppInputs.cCppPkgs ++ sharedInputs.sharedPkgs ++ auxInputs;
  shellHook = ''
    figlet -f slant "CUDA ENV"
  '';

  CUDA_PATH = "${pkgs.cudatoolkit}";
  LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}:$LD_LIBRARY_PATH";
  EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
  EXTRA_CCFLAGS = "-I/usr/include";
}
