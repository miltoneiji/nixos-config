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
      rev = "16c15ae8dc6303eba3fa656770c29747bfac5dbe";
      sha256 = "0v9vjcci2z0jlgfyrc7s2bdfmghz1kq492yx2b2h9c5aj6hxfh1i";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    sqlite
    gcc
  ];
}
