{ inputs, lib, pkgs, config, ... }:
with lib;
let
  cfg = config.oakos.desktop.hyprland;
in {

  options.oakos.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland; 
      systemd.setPath.enable = true;
      xwayland.enable = true;
    };

     # set default for sddm
     services.displayManager.defaultSession = "hyprland";
   };
 }
