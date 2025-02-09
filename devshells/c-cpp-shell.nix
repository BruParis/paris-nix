
{
  pkgs,
  cCppUtils,
  sharedUtils,
}:

# let
#   auxInputs = with pkgs; [];
# in
pkgs.mkShell {
  name = "c-cpp";
  packages = cCppUtils.cCppInputs ++ sharedUtils.sharedInputs;
  shellHook = ''
    figlet -f slant "C / C++ ENV"
  '';

}
