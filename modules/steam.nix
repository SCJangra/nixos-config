{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [ mangohud ];
  };

  programs.gamemode = {
    enable = true;
  };

  # Enable the Gamescope program/daemon
  programs.gamescope = {
    enable = true;
    capSysNice = false; # Optional: helps with frame pacing
  };

  # Add the WSI layer so Vulkan/Proton can negotiate HDR
  environment.systemPackages = with pkgs; [
    gamescope-wsi
  ];
}
