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
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

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
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

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


  # Define a user account. Don't forget to set a password with ???passwd???.
  users.users.takamura = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "plex" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    nix-prefetch-scripts # To obtain source hashes
    arandr # visual front end for xrandr
    pavucontrol # PulseAudio volume control
    font-manager # font management for GTK desktop environments
    flameshot # powerful yet simple to use screenshot software
    vim # vim
    git # git
    jq # command-line JSON processor
    nmap # network discovery and security auditing
    firefox # browser
    kitty # terminal
    fzf # general-purpose command-line fuzzy finder
    fd # `find` alternative
    mediainfo # info about videos and audio files
    vlc # video player
    nitrogen # wallpaper browser and setter for X11
    spotify # music player
    calibre # Comprehensive e-book sofware
    unzip # Extraction utility for .zip
    zoom-us # video conferencing application
    clojure # lisp dialect for JVM
    leiningen # project automation for Clojure
    qbittorrent # torrent client
    youtube-dl # Video downloader
    ruby # the Ruby language
    bundler # Ruby dependency manager
    bundix # Creates Nix packages from Gemfiles
    rubyPackages.rspec # Ruby test framework
    solargraph # A Ruby language server
    ledger # Double-entry accounting cli
    hledger # CLI for hledger accounting system
    hledger-web # Web-based interface for hledger
    anki # Spaced repetition flashcard program
    exfat # Free exFAT file system implementation
    libsForQt5.ark # Extract features in Dolphin
    bluez # Bluetooth support for Linux
    bluez-tools # CLI for bluez
    android-file-transfer # MTP client
    neofetch # System info script for ricing
    gotop # graphical activity monitor for ricing
    bazel # Build tool
    jetbrains.idea-community # Intellij
    jdk # Open-source Java development kit
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
    "spotify-unwrapped"
    "zoom"
    "plexmediaserver"
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

  # Control screen brightness via hotkeys.
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  # Torrent indexer service.
  # available at localhost:9117
  services.jackett = {
    enable = true;
  };

  services.plex = {
    enable = true;
    openFirewall = true;
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
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
