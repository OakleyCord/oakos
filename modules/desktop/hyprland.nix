{ lib, pkgs, config, ... }:
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
      xwayland.enable = true;
    };

     # set default for sddm
     services.displayManager.defaultSession = "hyprland";
   };
 }
