let
  pkgs = import (import ./nixpkgs.nix) { };
in
with pkgs; mkShell {
  shellHook = ''
    build() { morph build network.nix; }
    deploy() { morph deploy network.nix $*; }
  '';
  buildInputs = [
    morph
    mkpasswd
  ];
}