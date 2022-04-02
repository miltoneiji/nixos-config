{ config, pkgs, emacs-overlay, ... }:
let
  emacs-packages = emacs-overlay.overlay pkgs pkgs;
in
{
  programs.emacs = {
    enable = true;
    package = emacs-packages.emacsGcc;
  };

  # to get the rev and sha256
  # nix-prefetch-git https://github.com/miltoneiji/emacs.d
  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "miltoneiji";
      repo = "emacs.d";
      rev = "9142cc43ccc8a9956a881c6d287f13fae57cf724";
      sha256 = "117ib12xqgwxdgf0nrlvrc840cl2z9j6i2bjqwcll2jbqnhx2gib";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
  ];
}
