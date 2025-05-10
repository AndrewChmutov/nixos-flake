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
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    util = import ./util inputs;
  in {
    checks.${system}.statix = pkgs.statix;
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      barrel = util.sys.make "x86_64-linux" "barrel";
    };

    homeConfigurations = {
      barrel = util.home.make "x86_64-linux" "barrel";
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
