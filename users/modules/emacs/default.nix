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
      rev = "cb00b3bdd12fcf93a9c77fef99ef21153d9b79b0";
      sha256 = "1x9iwrnmnqr397pirzgyhr177xnl25gvchlcch0417pfhys5cspk";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
    metals # language server for scala
    ledger
  ];
}
