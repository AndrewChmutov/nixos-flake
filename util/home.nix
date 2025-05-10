inputs: {
  make = system: name:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        ../home/${name}/home-manager.nix
        inputs.zen-browser.homeModules.twilight
      ];
    };
}
