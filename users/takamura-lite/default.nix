{ config, pkgs, ... }:

{
  imports = [
    ../modules/vim.nix
    ../modules/git.nix
  ];

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

  home.username = "takamura";
  home.homeDirectory = "/home/takamura";
  home.stateVersion = "21.11";
  programs.home-manager.enable = true;
}
