{ inputs, config, pkgs, self, ... }:
{
  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;

  };

  # fix swaylock
  security.pam.services.swaylock = {};

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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

    # flatpak
    flatpak.enable = true;
    # Enable the KDE Plasma Desktop Environment.
    xserver.displayManager.sddm = {
      enable = true;
      theme = "rose-pine";
      # expiremental wayland support
      wayland.enable = true;
    };

    # set default for sddm
    xserver.displayManager.defaultSession = "hyprland";
  };
  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };
  fonts.fontDir.enable = true;
 
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

 # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    self.packages.${pkgs.system}.sddm-rose-pine
  ];

  
  programs.partition-manager.enable = true;

  security.pam.services.sddm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

}
