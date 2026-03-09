{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];

  boot.kernelModules = [ "i2c-dev" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Graphics and Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # portals for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };


  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  security.polkit.enable = true;
  # Voice
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # keyboard layout
  services.xserver.xkb = {
    layout = "us";
    options = "grp:alt_shift_toggle";
  };

  #user packages for rch
  users.users.rch2 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      discord
      vesktop
      vscodium
      kitty
      waybar
      wofi
      fastfetch
      fzf
      zoxide
      eza
      pciutils
      rofi
      btop
      telegram-desktop
      vencord
      swww
      spotify
      pkgs.gparted
      pkgs.kdePackages.partitionmanager
      prismlauncher
      libreoffice-fresh
    ];
  };


  programs.steam.enable = true;
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    # Fastfetch autostart
    interactiveShellInit = ''
      fastfetch --config ~/.config/fastfetch/config.jsonc
    '';

    # Starship
    promptInit = "eval \"$(starship init zsh)\"";
  };

  environment.systemPackages = with pkgs; [
    ntfs3g
    vim
    wget
    git
    curl
    lm_sensors
    libsForQt5.qt5ct
    libsForQt5.qt5ct
    kdePackages.qt6ct
    starship
    polkit_gnome
    hyprshot
    lxqt.pavucontrol-qt
    pavucontrol
    libnotify
    jq
    htop
    bc
    wireplumber
  ];

  fonts = {
    packages = with pkgs; [
      (nerd-fonts.jetbrains-mono)
      (nerd-fonts.caskaydia-cove)
      (nerd-fonts.mononoki)
      (nerd-fonts.symbols-only)
      noto-fonts
      font-awesome
    ];
    
    fontconfig = {
      enable = true;
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
      #default Fonts
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "CaskaydiaCove Nerd Font" ];
        serif = [ "CaskaydiaCove Nerd Font" ];
      };
    };
  };

  # NVIDIA drivers (RTX 3060)
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Discs configuration
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/426ADA256ADA158F";
    fsType = "ntfs-3g";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/hdd_win" = {
    device = "/dev/disk/by-uuid/C624536F2453620B";
    fsType = "ntfs-3g";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/default" = {
    device = "/dev/disk/by-uuid/1fc413c5-a0dc-4249-94ec-194e7786bb9a";
    fsType = "btrfs";
    options = [ "nofail" ];
  };
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/15c41b5a-9777-4a45-93dc-aebe238537c6";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  environment.sessionVariables = {
    PATH = [ "/home/rch2/.local/lib/hyde/" ];
    XDG_CONFIG_HOME = "/home/rch2/.local/share";
    # Cursor theme
    XCURSOR_THEME = "LyraQ";
    # Cursor size
    XCURSOR_SIZE = "24";
    # Force Qt to use the correct rendering engine
    QT_QPA_PLATFORM = "wayland";
  };
  programs.starship = {
    enable = true;
    # Style configuration
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

environment.variables = {
  GTK_THEME = "Adwaita:dark";
};	


  system.stateVersion = "24.11";
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];
  programs.nm-applet.enable = true;
}


