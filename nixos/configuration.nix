{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      configurationLimit = 5;
    };

    timeout = 0;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  networking = {
    hostName = "terra";
    networkmanager.enable = true;
  };

  time.timeZone = "Poland";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8"];
  };

  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "us,ru";
        options = "grp:alt_space_toggle";
      };

      displayManager.startx.enable = true;
      windowManager.awesome.enable = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    openssh.enable = true;
  };

  users.users.dust = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
  };

  hardware.bluetooth.enable = true;

  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          email = "ulman.andre@gmail.com";
          name = "Andrew Chmutov";
        };
      };
    };
    tmux = {
      enable = true;
      extraConfig = ''
        set-option -g default-shell "${pkgs.zsh}/bin/zsh"
      '';
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    btop
    curl
    evince
    fd
    ripgrep
    firefox
    fzf
    git
    kitty
    rustup
    uv
    xclip
    zathura
    unzip
    starship
    tmux
    zsh
    neovim
    gnumake
    nodejs_23
    llvmPackages_19.libcxxClang
    libgcc
    luajitPackages.luarocks
    luajit
    tree-sitter
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
