{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paris-nixvim.url = "github:BruParis/paris-nixvim";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      paris-nixvim,
      claude-code,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        paris-nix0 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                withHyprland = true;
                isNixOS = true;
              };
              home-manager.users.bruno = import ./home/home.nix;
            }
          ];
        };
      };

      homeConfigurations = {
        "bruno-nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            withHyprland = true;
            isNixOS = true;
          };
        };
        "bruno-fedora" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            withHyprland = false;
            isNixOS = false;
          };
        };
      };

      devShells.${system} = let
        sharedUtils = import ./devshells/shared-utils.nix { inherit pkgs; };
        cCppUtils = import ./devshells/c-cpp-utils.nix { inherit pkgs; };
      in {
        cuda = pkgs.callPackage ./devshells/cuda-shell.nix {
          inherit cCppUtils sharedUtils;
        };
        cCpp = pkgs.callPackage ./devshells/c-cpp-shell.nix {
          inherit cCppUtils sharedUtils;
        };
        python312 = pkgs.callPackage ./devshells/python312-shell.nix {
          inherit sharedUtils;
        };
      };

    };

}
