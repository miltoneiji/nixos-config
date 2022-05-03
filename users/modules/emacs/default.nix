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
      rev = "102a55f2f224ddfbb8c22b433e12608840e79786";
      sha256 = "0khm39fr39i2ddp2xqsx67w58chz9nfdfvhhp1hawba27wc5ahzl";
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
