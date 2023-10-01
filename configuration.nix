# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  home-manager.users.scj       = import ./home-manager.nix;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs   = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
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
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Fish
  programs.fish.enable               = true;

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.shells = with pkgs; [ fish ];
  environment.variables.LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
  environment.systemPackages = with pkgs; [
  # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    ripgrep
    fd
    brave
    dunst
    slurp
    lxqt.pcmanfm-qt
    lxqt.pavucontrol-qt
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.polkit-kde-agent
    libsForQt5.okular
    rofi-wayland
    mlocate
    hyprpaper
    gcc
    nodejs
    tree-sitter
    gnumake
    toybox
    signal-desktop
    vlc
    qbittorrent
    swww
    protonvpn-cli

    # Dev environment
    lua-language-server
    stylua
    nodePackages.vscode-langservers-extracted
    nil
    rustup
    protobuf
    clang
    glibc_multi
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Hyprland
  programs.hyprland.enable = true;

  # Neovim
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # fstab
  fileSystems."/run/media/scj/Storage".device  = "/dev/disk/by-label/Storage";
  fileSystems."/run/media/scj/Storage".fsType  = "ntfs";
  fileSystems."/run/media/scj/Storage".options = [ "uid=1000" "gid=100" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
