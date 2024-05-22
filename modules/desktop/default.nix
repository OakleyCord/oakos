{ inputs, self, lib, pkgs, config, ... }:
with lib;
let 
  cfg = config.oakos.desktop;
in {

  imports = [
    ./hyprland.nix
    ./plasma6.nix
  ];

  options.oakos.desktop = {
    enable = mkEnableOption "Enable Default Desktop Config";
  };

  config = mkIf cfg.enable {
    hardware = {
      opengl.enable = true;
      opengl.driSupport = true;
      opengl.driSupport32Bit = true;
    };

    # fix swaylock
    security.pam.services.swaylock = {};

    # File manager
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs.enable = true;

    services = {
      xserver.enable = true;

      flatpak.enable = true;
      displayManager.sddm = {
        enable = true;
        theme = "rose-pine";
        wayland.enable = true;
      };
    };
    xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };
    fonts.fontDir.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    environment.systemPackages = with pkgs; [
      self.packages.${pkgs.system}.sddm-rose-pine
      piper
    ];


    programs.partition-manager.enable = true;

    security.pam.services.sddm.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;

    # Gaming mouse stuffs
    services.ratbagd.enable = true;

  };
}
