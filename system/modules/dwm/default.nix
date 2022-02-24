{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = builtins.fetchGit {
          url = "git://git.suckless.org/dwm";
          rev = "cb3f58ad06993f7ef3a7d8f61468012e2b786cab";
        };
        patches = [
          ./patches/dwm-fullgaps-6.2.diff
          ./patches/dwm-cool-autostart-6.2.diff
          ./patches/dwm-fullscreen-6.2-custom.diff
          ./patches/customization.diff
        ];
      });
    })
  ];
}
