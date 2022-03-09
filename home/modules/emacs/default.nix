{ config, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
  };

  # to get the rev and sha256
  # nix-prefetch-git https://github.com/miltoneiji/emacs.d
  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "miltoneiji";
      repo = "emacs.d";
      rev = "0c7f8319dd51154aa084dfa76e9a70a4c2303b6d";
      sha256 = "13ys7njnbxy12ja6qlv97f70mch1m982xr51mrww73mnxbrk08mr";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
