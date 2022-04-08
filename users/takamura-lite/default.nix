{ config, pkgs, ... }:

{
  imports = [
    ../modules/vim.nix
    ../modules/git.nix
  ];

  home.username = "takamura";
  home.homeDirectory = "/home/takamura";

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

  # This value determines the Home Manager release that your configuration is compatible
  # with.
  home.stateVersion = "21.11";

  # Let Home manager install and manage itself
  programs.home-manager.enable = true;
}
