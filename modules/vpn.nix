{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vpn;

  config-by-location = {
    "madrid" = "config /home/takamura/vpn/madrid-udp.ovpn";
    "dublin" = "config /home/takamura/vpn/dublin-udp.ovpn";
  };

  mkConfigFor = location: {
    autoStart = false;
    config = config-by-location."${location}";
    authUserPass = {
      username = "username";
      password = "password";
    };
  };
in
{
  options.services.vpn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Create services with name `openvpn-<location>`.
      '';
    };
  };

  config = {
    services.openvpn.servers = mkIf cfg.enable {
      dublin = mkConfigFor "dublin";
      madrid = mkConfigFor "madrid";
    };
  };
}
