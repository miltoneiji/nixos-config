{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "takamura";
  home.homeDirectory = "/home/takamura";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    userName = "Milton Eiji Takamura";
    userEmail = "miltontakamura@gmail.com";
    ignores = [ "*.swp" ];
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
      theme = "risto";
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
    extraConfig = "inoremap jk <esc>";
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-airline
      vim-sensible
      vim-nix
    ];
  };

  # This value determines the Home Manager release that your configuration is compatible
  # with.
  home.stateVersion = "21.11";

  # Let Home manager install and manage itself
  programs.home-manager.enable = true;
}
