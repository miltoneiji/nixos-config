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
      rev = "cfbbba6448ec4cf20e089ccd95a3dff7887cdd8e";
      sha256 = "1wbj17h50pd8lplvzj6g7249aijyvgbg9ri6vmis0zzd5svxa9rk";
    };
  };

  home.packages = with pkgs; [
    fd
    silver-searcher
    metals # language server for scala
  ];
}
