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
      rev = "78bf112c5da4511208f8d0141efb302c147a7a7a";
      sha256 = "0lz4zc08yf8m1ci5zr8fzhv6xfa9fc8pkbhy2l27kqc5v76ys71n";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
    metals # language server for scala
  ];
}
