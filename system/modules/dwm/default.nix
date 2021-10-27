{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
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
