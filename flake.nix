{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs =
        pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true;

          # FIXME: hotfix for freeimage-unstable-2021-11-01 for megasync
          config.permittedInsecurePackages = [ "freeimage-unstable-2021-11-01" ];

          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };
      pkgs = mkPkgs nixpkgs [ self.overlay ];

      lib = nixpkgs.lib.extend (
        self: super: {
          my = import ./lib {
            inherit pkgs inputs;
            lib = self;
          };
        }
      );
    in
    {
      lib = lib.my;

      overlay = final: prev: {
        unstable = pkgs;
        my = self.packages."${system}";
      };

      overlays = mapModules ./overlays import;

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShells.${system}.default = with pkgs; mkShell {
          packages = [
            nixfmt
          ];
        };
    };
}
