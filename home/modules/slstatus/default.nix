{ pkgs, ... }:

let
  slstatus = pkgs.slstatus.overrideAttrs (oldAttrs: rec {
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
