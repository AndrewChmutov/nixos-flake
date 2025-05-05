{pkgs, ...}: {
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
    hostName = "barrel";
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

      autoRepeatInterval = 25;
      autoRepeatDelay = 250;

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

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';

    openssh.enable = true;
  };

  systemd.sockets.docker.enable = false;

  users.users.diogenes = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
  };

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vpl-gpu-rt
      ];
    };
  };

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

  environment = {
    systemPackages = with pkgs; [
      curl
      evince
      git
      unzip
      xclip
      tmux
      neovim
    ];
    variables = {
      MOZ_USE_XINPUT2 = 1;
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
