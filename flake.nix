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
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");

  in {
    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit device;
          inherit hostname;
          inherit secrets;
        };

        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs.flake-inputs = inputs;
            imports = [
              ./users/petere/home.nix
            ];
          }
          ./configuration.nix {inherit secrets;}
          ./modules/systemfonts.nix
        ];
      };
    };
  };
}

