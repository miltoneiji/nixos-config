{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Milton Eiji Takamura";
    userEmail = "miltontakamura@gmail.com";
    delta.enable = true;
    ignores = [ "*.swp" ".#*" "\\#*#" ];
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "current";
      pull.rebase = false;
    };
  };
}
