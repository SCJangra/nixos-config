{ pkgs, ... }: {
  home.username      = "scj";
  home.homeDirectory = "/home/scj";
  home.stateVersion  = "23.05";

  programs.home-manager.enable = true;

  # Fish
  programs.fish.enable               = true;
  programs.fish.interactiveShellInit = builtins.readFile ./config/fish/config.fish;

  # Git
  programs.git.enable    = true;
  programs.git.userName  = "Sachin Charakhwal";
  programs.git.userEmail = "sachincharakhwal@gmail.com";

  # Starship
  programs.starship.enable                       = true;
  programs.starship.enableFishIntegration        = true;
  programs.starship.settings.lua.symbol          = " ";
  programs.starship.settings.git_branch.symbol   = " ";
  programs.starship.settings.git_status.diverged = "";
  programs.starship.settings.git_status.ahead    = "";
  programs.starship.settings.git_status.behind   = "";

  # Direnv
  programs.direnv.enable            = true;
  programs.direnv.nix-direnv.enable = true;

  # Exa
  programs.exa.enable        = true;
  programs.exa.enableAliases = true;
  programs.exa.git           = true;
  programs.exa.icons         = true;

  # Kitty
  programs.kitty.enable      = true;
  programs.kitty.extraConfig = builtins.readFile ./config/kitty/kitty.conf;

  # Elkowars Wacky Widgets
  programs.eww.enable    = true;
  programs.eww.configDir = ./config/eww;

  # Notifications
  services.dunst.enable            = true;
  services.dunst.configFile        = ./config/dunst/dunstrc;
  services.dunst.iconTheme.name    = "Papirus-Dark";
  services.dunst.iconTheme.package = pkgs.papirus-icon-theme;

  # Control media players using controls on bluttooth headsets
  services.mpris-proxy.enable = true;

  # GTK
  gtk.enable            = true;
  gtk.iconTheme.package = pkgs.papirus-icon-theme;
  gtk.iconTheme.name    = "Papirus-Dark";
  gtk.theme.package     = pkgs.orchis-theme;
  gtk.theme.name        = "Orchis-Teal-Dark-Compact";
  gtk.cursorTheme.name  = "BreezeX-Dark";
  gtk.cursorTheme.size  = 28;

  home.sessionVariables = {
    EDITOR = "nvim";

    # Log WLR errors and logs to the hyprland log. Recommended
    HYPRLAND_LOG_WLR = 1;

    # Example IME Support: fcitx
    GTK_IM_MODULE  = "fcitx";
    QT_IM_MODULE   = "fcitx";
    XMODIFIERS     = "@im=fcitx";
    SDL_IM_MODULE  = "fcitx";
    GLFW_IM_MODULE = "ibus";

    # QT
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
