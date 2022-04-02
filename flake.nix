{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, home-manager, nixpkgs, emacs-overlay, ... }:
    let
      mkHomeManagerConfig = { extraSpecialArgs ? {}, usersConfig }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = extraSpecialArgs;
          home-manager.users = usersConfig;
        };

      mkSystem = system: { modules }:
        nixpkgs.lib.nixosSystem {
          inherit system modules;
        };
    in
      {
        nixosConfigurations = {
          nixos = mkSystem "x86_64-linux" {
            modules = [
              ./hosts/nixos
              home-manager.nixosModules.home-manager
              (mkHomeManagerConfig {
                extraSpecialArgs = { inherit emacs-overlay; };
                usersConfig.takamura = import ./users/takamura;
              })
            ];
          };

          laptop = mkSystem "x86_64-linux" {
            modules = [
              ./hosts/laptop
              home-manager.nixosModules.home-manager
              (mkHomeManagerConfig {
                extraSpecialArgs = { inherit emacs-overlay; };
                usersConfig.takamura = import ./users/takamura;
              })
            ];
          };
        };
      };
}
