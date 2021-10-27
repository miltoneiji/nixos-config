{ config, pkgs, ... }:

let
  dmenu = pkgs.dmenu.overrideAttrs (oldAttrs: rec {
    patches = [
      ./patches/dmenu-border-4.9.diff
      ./patches/dmenu-center-20200111-8cd37e1.diff
      ./patches/customization.diff
    ];
  });
in
  {
    home.packages = [
      dmenu
    ];
  }
