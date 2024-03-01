{ inputs, config, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # set default for sddm
  services.xserver.displayManager.defaultSession = "hyprland";
}
