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
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-airline
      vim-sensible
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.hack-font;
      name = "Hack";
      size = 15;
    };
    settings = {
      scrollback_lines = 10000;
      background_opacity = "0.95";

      background           = "#000000";
      foreground           = "#FBFBFB";
      cursor               = "#5277C3";
      selection_background = "#B5B5FF";
      selection_foreground = "#000000";
      color0               = "#000000";
      color8               = "#222222";
      color1               = "#DC5858";
      color9               = "#F86363";
      color2               = "#5ED966";
      color10              = "#6EFF78";
      color3               = "#B37021";
      color11              = "#F1972C";
      color4               = "#5277C3";
      color12              = "#6694F3";
      color5               = "#C15FB3";
      color13              = "#F378E1";
      color6               = "#7EBAE4";
      color14              = "#8DD0FF";
      color7               = "#FBFBFB";
      color15              = "#FFFFFF";
    };
  };

  # A modern replacement for `ls`
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}
