{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/vpn
    ];

  # Raspberry PI 4B specifics
  boot = {
    loader.timeout = 1;
    loader.grub.enable = false;
    loader.raspberryPi.enable = true;
    loader.raspberryPi.version = 4;
    kernelPackages = pkgs.linuxPackages_rpi4;
  };

  networking = {
    hostName = "raspberry";
    wireless = {
      enable = true;
      networks = import ../../secrets/wifi.nix;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "us";
  };

  users = {
    mutableUsers = false;
    users.takamura = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "media" ];
      hashedPassword = "$6$TBpSszWv6jZtGapk$qMzDy0ZpHqWAZ0mKQ/NknHjIShZzo1VENOZrWPx2.GsRDEnTIBhtJjnK8DiicxbrhRxhTjcs5BXjhHhGv0cdh1";
    };

    groups = {
      media = {};
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    fd
    fzf
  ];

  # VPN
  services.vpn = {
    enable = true;
    autoStartLocation = "madrid";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # API Support for your favorite torrent trackers
  # http://[::]:9117
  services.jackett = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  # The Free Software Media System
  # http://[::]:8096
  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  # A Usenet/BitTorrent movie downloader
  # http://[::]:7878
  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  # Smart PVR for nesgroup and bittorrent users
  # http://[::]:8989
  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  # Subtitle manager for Sonarr and Radarr
  # http://[::]:6767
  services.bazarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  # A fast, easy and free BitTorrent client
  # http://[::]:9091
  services.transmission = {
    enable = false;
    group = "media";
    openRPCPort = true;
    settings = {
      downloads-dir = "/library/movies";
      incomplete-dir = "/library/incomplete";
      watch-dir-enabled = true;
      watch-dir = "/library/blackhole";
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "plexmediaserver"
    "unrar"
  ];

  # Cleaning the Nix Store
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };

  # Enabling flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
