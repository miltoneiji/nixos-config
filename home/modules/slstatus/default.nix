{ pkgs, ... }:

let
  slstatus = pkgs.slstatus.overrideAttrs (oldAttrs: rec {
    src = builtins.fetchGit {
      url = "https://git.suckless.org/slstatus";
      rev = "b14e039639ed28005fbb8bddeb5b5fa0c93475ac";
    };
    patches = [
      ./patches/customization.diff
    ];
  });
in
  {
    home.packages = [
      slstatus
    ];
  }
