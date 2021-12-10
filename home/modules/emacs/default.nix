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
      rev = "9874ba227044df5e19b95b3086ee6bd4c49064c6";
      sha256 = "15vim6ynisxxkrqx08l4bxrmlh0bj4r0arr0ycgxx0xy7fry8ylp";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    sqlite
    gcc
  ];
}
