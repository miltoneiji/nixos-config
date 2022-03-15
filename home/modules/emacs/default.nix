{ config, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
  };

  # to get the rev and sha256
  # nix-prefetch-git https://github.com/miltoneiji/emacs.d
  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "miltoneiji";
      repo = "emacs.d";
      rev = "843c740b37cf0a604b898f585b46cb24a8ab03cf";
      sha256 = "1ih348w8s36nvql914lxd3jgb6y67ms1gx9x243375rs5dc3nvdy";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
