{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    settings = {
      background = "dark";
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      number = true;
      ignorecase = true;
      undodir = [ "/tmp" ];
      undofile = true;
    };
    extraConfig = ''
      inoremap jk <esc>
    '';
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-airline
      vim-sensible
      vim-nix
      vim-scala
      vim-ruby
      vim-yaml
      fzf-vim
    ];
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
