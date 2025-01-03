
{
  pkgs,
  cCppInputs,
  sharedInputs,
}:

# let
#   auxInputs = with pkgs; [];
# in
pkgs.mkShell {
  name = "c-cpp";
  buildInputs = cCppInputs.cCppPkgs ++ sharedInputs.sharedPkgs;
  shellHook = ''
    figlet -f slant "C / C++ ENV"
  '';

}
