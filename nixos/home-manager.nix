{pkgs, ...}: {
  home = {
    username = "diogenes";
    homeDirectory = "/home/diogenes/";
    stateVersion = "24.11";
    sessionVariables = {
      RUSTUP_TOOLCHAIN = "stable";
    };
  };

  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      extraPackages = with pkgs; [
        gnumake
        nodejs_23
        llvmPackages_19.libcxxClang
        libgcc
        luajitPackages.luarocks
        luajit
        tree-sitter
        cargo
      ];
    };
  };
}
