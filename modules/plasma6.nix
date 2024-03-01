{ inputs, config, pkgs, ... }:
{

  services.xserver.desktopManager.plasma6.enable = true;

  # set default for sddm
  services.xserver.displayManager.defaultSession = "plasma-wayland";
}
