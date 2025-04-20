{
  description = "My First flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

      };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    device = "t470";
    hostname = "peter-laptop";
    pkgs = import nixpkgs { inherit system; };

  in {
    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit device;
          inherit hostname;
        };

        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs.flake-inputs = inputs;
          }
          ./configuration.nix
          ./modules/systemfonts.nix
          ./users/petere/home.nix
        ];

                
      };
    };
  };
}

