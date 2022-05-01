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
      rev = "123070a241adb0b66b1c8ed0709566284db637d5";
      sha256 = "0h4wah8gnc4rlrq9n4a26cpdryjvxddiqkdqygcpayhqg2nia0mq";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
    metals # language server for scala
    ledger
  ];
}
