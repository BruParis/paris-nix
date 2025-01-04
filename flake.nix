{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    paris-nixvim.url = "github:BruParis/paris-nixvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hyprland,
      paris-nixvim,
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
              home-manager.users.bruno = import ./home/home.nix;
            }
          ];
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
