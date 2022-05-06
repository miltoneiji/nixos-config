{ config, pkgs, emacs-overlay, ... }:
let
  emacs-packages = emacs-overlay.overlay pkgs pkgs;
in
{
  programs.emacs = {
    enable = true;
    package = emacs-packages.emacsGcc;
  };

  # Update instructions:
  #   In this directory, run ./update.sh
  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "miltoneiji";
      repo = "emacs.d";
      rev = "ca41490defcad405d684ccab32ef6676e4776d4f";
      sha256 = "1yxb1gqgc0zhc4h01mv95fbq6497w1dyw457gbsiab6w02h3nc84";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
    metals # language server for scala
    ledger
    xclip # Tool to access the X clipboard from a console application
  ];
}
