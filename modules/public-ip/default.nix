{ pkgs, ... }:

with pkgs;

let
  public-ip = stdenv.mkDerivation {
    name = "public-ip";
    src = ./.;
    buildInputs = [ bash curl ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp public-ip.sh $out/bin/public-ip
      wrapProgram $out/bin/public-ip \
        --prefix PATH : ${lib.makeBinPath [ bash curl ]}
    '';
  };
in
{
  environment.systemPackages = [
    public-ip
  ];
}
