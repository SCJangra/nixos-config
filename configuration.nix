# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  nix.channel.enable = true;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];

  home-manager.users.scj       = import ./home-manager.nix { pkgs = pkgs; inputs = inputs; };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs   = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.hostName              = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable polkit
  security.polkit.enable = true;

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable Audio/Video
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Auto detect partitions, usb drives and mtp devices
  services.gvfs.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    fish     = { enable = true; };
    hyprland = { enable = true; };
    neovim   = {
      enable        = true;
      defaultEditor = true;
      withNodeJs    = true;
    };
    command-not-found = { enable = false; };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.fish;
  users.users.scj = {
    isNormalUser = true;
    description = "Sachin Charakhwal";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "scj";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.shells = with pkgs; [ fish ];
  environment.systemPackages = with pkgs; [
    brave
    curl
    fd
    kdePackages.okular
    kdePackages.qtstyleplugin-kvantum
    lxqt.pavucontrol-qt
    lxqt.pcmanfm-qt
    libsForQt5.qtstyleplugin-kvantum
    protonvpn-cli
    qbittorrent
    ripgrep
    rofi-wayland
    signal-desktop
    slurp
    swww
    toybox
    tree-sitter
    vlc
    wget
    wl-clipboard
    unrar
    socat
    jq
    pgadmin4-desktopmode
    eww
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  # fstab
  fileSystems."/run/media/scj/Storage".device  = "/dev/disk/by-label/Storage";
  fileSystems."/run/media/scj/Storage".fsType  = "ntfs-3g";
  fileSystems."/run/media/scj/Storage".options = [ "rw" "uid=1000" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
