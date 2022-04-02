{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.services.vpn;

  config-by-location = {
    "madrid" = readFile ../../secrets/vpn-configs/madrid-udp.ovpn;
    "dublin" = readFile ../../secrets/vpn-configs/dublin-udp.ovpn;
    "sao-paulo" = readFile ../../secrets/vpn-configs/sao-paulo-udp.ovpn;
  };

  mkConfigFor = location: {
    autoStart = false;
    config = config-by-location."${location}";
    authUserPass = with (fromJSON (readFile ../../secrets/vpn-auth.json)); {
      inherit username password;
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
      sao-paulo = mkConfigFor "sao-paulo";
    };
  };
}
