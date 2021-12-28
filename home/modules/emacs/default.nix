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
      rev = "16352703f99251bb90f542cc40a3121010657434";
      sha256 = "1qpa7a3lcg2jja3lqw9zvq170jcdr1cxj5xaw512jv7lpw38xaas";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    sqlite
    gcc
  ];
}
