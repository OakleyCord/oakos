{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.oakos.desktop.plasma6;
in {

  options.oakos.desktop.plasma6 = {
    enable = mkEnableOption "Enable Plasma6";
  };

  config = mkIf cfg.enable {

    services.desktopManager.plasma6.enable = true;

    # set default for sddm
    services.displayManager.defaultSession = "plasma";
  };
}
