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
      rev = "933f5774604382062733b616b99bcac78dacf0fc";
      sha256 = "0y1jl64qkwyrv3d7kbrijn608gsgv55gffjjdx104fk2yikddfkc";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    sqlite
    gcc
  ];
}
