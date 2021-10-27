{ config, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
  };

  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "miltoneiji";
      repo = "emacs.d";
      rev = "4dbb205bdefaee84b40fb683a691ea64a5b465b4";
      sha256 = "10c2n9ldyirm3w4g8hymzrvn508az2h42g8m84pp1qjlzmykf6ml";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    sqlite
    gcc
  ];
}
