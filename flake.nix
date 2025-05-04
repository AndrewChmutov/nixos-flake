{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs: let
    inherit (inputs) home-manager nixpkgs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    checks.${system}.statix = pkgs.statix;
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      barrel = nixpkgs.lib.nixosSystem {
        modules = [./nixos/configuration.nix];
      };
    };

    homeConfigurations = {
      barrel = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nixos/home-manager.nix
          inputs.zen-browser.homeModules.twilight
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        statix
        alejandra
        pre-commit
        typos
      ];
    };
  };
}
