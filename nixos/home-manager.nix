{
  lib,
  pkgs,
  ...
}: let
  reposDir = "/home/diogenes/dev/pet/";
in {
  home = {
    username = "diogenes";
    homeDirectory = "/home/diogenes/";
    stateVersion = "24.11";

    packages = with pkgs; [
      git
      gnumake
      openssh
      tmux
      gawk
      scc
      btop
      fd
      ripgrep
      fzf
      kitty
      rustup
      uv
      zathura
      starship
      zsh
      trippy
      telegram-desktop
      python313
      xsecurelock
      acpi
      acpilight
      jmtpfs
      pulseaudio
      fuse
      pavucontrol
      sof-firmware
    ];

    activation = {
      cloneStandaloneConfigs = lib.hm.dag.entryAfter ["writeBoundary" "installPackages"] ''
        export GIT_SSH_COMMAND=${pkgs.openssh}/bin/ssh
        export PATH=$PATH:${pkgs.git}/bin/
        export PATH=$PATH:${pkgs.gnumake}/bin/
        export PATH=$PATH:${pkgs.neovim}/bin/
        export PATH=$PATH:${pkgs.tmux}/bin/
        export PATH=$PATH:${pkgs.gawk}/bin/

        mkdir -p "${reposDir}"

        cloneIfNone() {
          if [ ! -d "${reposDir}$1" ]; then
            git clone git@github.com:andrewchmutov/$1 "${reposDir}$1" --recursive
            make force -C "${reposDir}$1"
          fi
        }

        cloneIfNone awesome
        cloneIfNone nvim
        cloneIfNone tmux
        cloneIfNone kitty
        cloneIfNone zshrc
        cloneIfNone trippy
        cloneIfNone zathura
      '';
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
    zen-browser = {
      enable = true;
      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
      };
    };
  };
}
