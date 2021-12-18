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
      rev = "1ef183fbaca09f686ab66a5ae34b7e2f79735a71";
      sha256 = "0wwhm33gl3z5n69m582awry3nq2smaz3j6va1a2blc0832ryzlq2";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    sqlite
    gcc
  ];
}
