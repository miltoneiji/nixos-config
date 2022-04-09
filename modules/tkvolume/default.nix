{ pkgs, ... }:

with pkgs;

let
  tkvolume = stdenv.mkDerivation {
    name = "tkvolume";
    src = ./.;
    buildInputs = [ bash pamixer ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp tkvolume $out/bin/tkvolume
      wrapProgram $out/bin/tkvolume \
        --prefix PATH : ${lib.makeBinPath [ bash pamixer ]}
    '';
  };
in
{
  environment.systemPackages = [ tkvolume ];
}
