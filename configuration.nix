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

  nix.channel.enable = false;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];

  nixpkgs.config.allowUnfree = true;

  home-manager.users.scj       = import ./home-manager.nix { pkgs = pkgs; inputs = inputs; };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs   = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.hostName              = "scj-main"; # Define your hostname.
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

  # Power management
  services.upower.enable = true;

  # Aria2 download manager
  environment.etc."aria2/secret.txt" = {
    text = "no-secret";
    mode = "0400";
  };
  services.aria2 = {
    enable = true;
    rpcSecretFile = "/etc/aria2/secret.txt";
    settings = {
      enable-rpc = true;
      rpc-allow-origin-all = true;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts."main.home.lan" = {
      locations."/downloads/" = {
        alias = "${pkgs.ariang}/share/ariang/";
        index = "index.html";
        extraConfig = "autoindex on;";
      };
      locations."/downloads" = {
        return = "301 /downloads/";
      };
      locations."/aria2/jsonrpc" = {
        proxyPass = "http://127.0.0.1:6800/jsonrpc";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
        '';
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    fish     = { enable = true; };
    hyprland = { enable = true; };
    command-not-found = { enable = false; };

    light.enable = true;
    light.brightnessKeys.enable = true;
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
    lxqt.lxqt-archiver
    kdePackages.qtstyleplugin-kvantum
    protonvpn-cli
    qbittorrent
    ripgrep
    walker
    signal-desktop
    slurp
    swww
    toybox
    tree-sitter
    vlc
    wget
    wl-clipboard
    unrar
    unzip
    socat
    jq
    pgadmin4-desktopmode
    eww
    telegram-desktop
    ariang
    friture
    qsynth
    vmpk
    ardour
    (pkgs.stdenv.mkDerivation {
      name = "fluida";
      src = inputs.fluida;
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/lv2
        cp -r ./* $out/lib/lv2/
        runHook postInstall
      '';
    })
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.symbols-only
    (pkgs.stdenv.mkDerivation {
      name = "iosevka";
      src = inputs.iosevka;
      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts
        cp ./*.ttf $out/share/fonts/
        runHook postInstall
      '';
    })
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
