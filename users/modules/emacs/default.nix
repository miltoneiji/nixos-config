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
      rev = "ad13a9eb3f4480587942825b8da49b2ae7c6fec1";
      sha256 = "03ij1mld6pq9dns35mpl4izwpx1hzzv1bipa4j3d83qdqxd2gbzy";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
    metals # language server for scala
    ledger
  ];
}
