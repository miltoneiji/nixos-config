{ config, pkgs, ... }:

let
  mypolybar = pkgs.polybar.override {
    alsaSupport = true;
    pulseSupport = true;
  };

  xmonad = ''
    [module/xmonad]
    type = custom/script
    exec = ${pkgs.xmonad-log}/bin/xmonad-log

    tail = true
'';
in
  {
    services.polybar = {
      enable = true;
      package = mypolybar;
      config = ./config.ini;
      extraConfig = xmonad;
      script = ''
polybar top &
'';
    };
  }
