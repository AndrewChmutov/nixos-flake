{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    checks.${system}.statix = pkgs.statix;
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      terra = nixpkgs.lib.nixosSystem {
        modules = [./nixos/configuration.nix];
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
