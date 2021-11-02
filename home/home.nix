{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./modules/emacs/default.nix

    ./modules/dmenu/default.nix
    ./modules/slstatus/default.nix
  ];

  home.username = "takamura";
  home.homeDirectory = "/home/takamura";

  home.stateVersion = "21.05";

  home.file.".scripts" = {
    source = ./scripts;
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    userName = "Milton Eiji Takamura";
    userEmail = "miltontakamura@gmail.com";
    delta.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "simple";
    };
    shellAliases = {
      p = "cd $(fd . '/home/takamura/repos/' -d 1 -i | fzf)";
    };
  };

  programs.vim = {
    enable = true;
    settings = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      number = true;
      ignorecase = true;
    };
    extraConfig = ''
      inoremap jk <esc>
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.jetbrains-mono;
      name = "JetBrainsMono";
      size = 15;
    };
    settings = {
      scrollback_lines = 5000;

      background           = "#050E0E";
      foreground           = "#FBFBFB";
      cursor               = "#33A1DB";
      selection_background = "#B5B5FF";
      selection_foreground = "#050E0E";
      color0               = "#050E0E";
      color8               = "#545454";
      color1               = "#FF5555";
      color9               = "#FF5555";
      color2               = "#55FF55";
      color10              = "#55FF55";
      color3               = "#FFFF55";
      color11              = "#FFFF55";
      color4               = "#7CA2B6";
      color12              = "#7CA2B6";
      color5               = "#FF55FF";
      color13              = "#FF55FF";
      color6               = "#33A1DB";
      color14              = "#49C6DB";
      color7               = "#BBBBBB";
      color15              = "#FBFBFB";
    };
  };

  # A modern replacement for `ls`
  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  home.packages = with pkgs; [
    qbittorrent  # torrent client
  ];
}
