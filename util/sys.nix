inputs: {
  make = system: name:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [../sys/${name}/configuration.nix];
    };
}
