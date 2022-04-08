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
      rev = "00c0e97fad8bde90cb786e7b739811ad29647a4d";
      sha256 = "00n4vly0dz8nz1aq9j54qkkbbdn2s777rpwbhk9kb76ni7q5wxmm";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
    metals # language server for scala
  ];
}
