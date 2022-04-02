{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./modules/emacs/default.nix
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
    ignores = [ "*.swp" ".#*" "\\#*#" ];
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "current";
    };
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
    initExtra = ''
      open() {
        if [ -f "$1" ]; then
          case $1 in
            *.png)  kitty +kitten icat $1                    ;;
            *.jpg)  kitty +kitten icat $1                    ;;
            *.jpeg) kitty +kitten icat $1                    ;;
            *.svg)  kitty +kitten icat $1                    ;;
            *.pdf)  firefox $1                               ;;
            *)      echo "'$1' cannot be opened in terminal" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      ex() {
        if [ -f "$1" ]; then
          case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
    '';
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
      vim-nix
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.hack-font;
      name = "Hack";
      size = 23;
    };
    settings = {
      scrollback_lines = 10000;
      background_opacity = "0.85";

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
