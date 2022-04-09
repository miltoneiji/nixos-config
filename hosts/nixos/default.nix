{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/dwm
      ../../modules/dmenu
      ../../modules/slstatus
      ../../modules/mongosh
      ../../modules/vpn
      ../../modules/public-ip
      ../../modules/tkvolume
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking = {
    hostName = "nixos";
    wireless = {
      enable = true;
      networks = import ../../secrets/wifi.nix;
    };
  };

  # I don't need Internet to boot my pc
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Used by redshift.
  location = {
    provider = "manual";
    longitude = -46.63;
    latitude = -23.61;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = false;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Create services `openvpn-dublin`, `openvpn-madrid`, etc
  # Usage: `systemctl start openvpn-<location>`
  services.vpn = {
    enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # Enable the Plasma 5 Desktop Environment.
    desktopManager.plasma5.enable = true;

    displayManager.sddm.enable = true;
    displayManager.sessionCommands = ''
      nitrogen --restore
    '';

    windowManager.dwm.enable = true;

    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        tapping = true;
        scrollMethod = "twofinger";
        naturalScrolling = true;
      };
    };

    layout = "us";
    xkbVariant = "alt-intl";
    xkbOptions = "caps:escape";
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;
  };

  # Compositor
  services.picom = {
    enable = true;
  };

  # Sound
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users = {
    users.takamura = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "media" ];
    };

    groups.media = {}; # media management
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git-crypt # Transparent file encryption in git
    vim # vim
    git # git
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    kitty # terminal
    jq # command-line JSON processor
    fzf # general-purpose command-line fuzzy finder
    fd # `find` alternative
    sqlite-web
    nix-prefetch-scripts # To obtain source hashes
    nmap # network discovery and security auditing
    mediainfo # info about videos and audio files
    vlc # video player
    unzip # Extraction utility for .zip
    youtube-dl # Video downloader
    exfat # Free exFAT file system implementation
    libsForQt5.ark # Extract features in Dolphin
    android-file-transfer # MTP client
    pciutils # Collection of programs for inspecing PCI devices
    rpi-imager # Raspberry Pi imaging utility
    pamixer # Pulseaudio command line mixer

    firefox # browser
    spotify # music player
    arandr # visual front end for xrandr
    pavucontrol # PulseAudio volume control
    font-manager # font management for GTK desktop environments
    zoom-us # video conferencing application
    calibre # Comprehensive e-book sofware
    anki # Spaced repetition flashcard program
    qbittorrent # torrent client
    jetbrains.idea-community # Intellij
    bluez # Bluetooth support for Linux
    bluez-tools # CLI for bluez
    nitrogen # wallpaper browser and setter for X11

    spark2

    # Scala development
    scala
    sbt

    # Clojure development
    clojure # lisp dialect for JVM
    leiningen # project automation for Clojure

    # Ricing
    neofetch # System info script for ricing
    cmatrix # Simulates the display from "The Matrix"
    gotop # graphical activity monitor for ricing
    tty-clock # Digital clock in ncurses
    cava # Console-based Audio Visualizer for Alsa
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
    "spotify-unwrapped"
    "zoom"
    "nvidia-x11"
    "nvidia-settings"
  ];

  # This fixes 'blank' windows when opening Intellij
  environment.variables._JAVA_AWT_WM_NONREPARENTING = "1";

  fonts.fonts = with pkgs; [
    hack-font
    fira-code
    fira-code-symbols
    source-code-pro
    jetbrains-mono
    nanum-gothic-coding
  ];

  # Torrent indexer service.
  # available at localhost:9117
  services.jackett = {
    enable = true;
  };

  # Screen color temperature manager.
  services.redshift = {
    enable = true;
  };

  # Cleaning the Nix Store
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };

  # Enable Flakes.
  nix = {
    package = pkgs.nixUnstable;
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
  system.stateVersion = "21.05"; # Did you read the comment?
}
