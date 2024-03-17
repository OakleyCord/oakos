{ inputs, config, pkgs, ... }:
{
  imports = [
    ../waybar/waybar.nix
    ../swaync/swaync.nix
    inputs.anyrun.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    # screnshotting
    sway-contrib.grimshot
    grim
    slurp
    swappy

    # for replays / quick recordings
    wl-screenrec

    # notifications
    swaynotificationcenter

    # wallpaper
    swww


    # networking :3
    networkmanagerapplet

    # clipboard
    wl-clipboard

    # display management
    nwg-displays
    wlr-randr


    # widgets (unused)
    eww
  ];

  home.file = {
    ".config/hypr/scripts" = {
      source = ./scripts;
      recursive = true;
      executable = true;
    };
  };

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      layer = "overlay";
      hidePluginInfo = true;
    };

    extraCss = ''
    window {
      background: transparent;
    }
    '';
  };

  # TODO: this whole thing is kinda a nothing burger does exactly the same without this config need to add config that fixes xdg open to this.
  xdg.portal = {
    enable = true;

    configPackages = [
      inputs.hyprland.packages.${pkgs.system}.hyprland
    ];

    extraPortals = with pkgs; [
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    #xdgOpenUsePortal = true;
  };
  programs.swaylock.enable = true;

  # bluetooth :]
  services.blueman-applet.enable = true;

  # Network manager
  services.network-manager-applet.enable = true;

  # on screen display
  # service broken due to change in command name (swayosd -> swayosd-server)
  # see home/hypr/scripts/autostart.sh
  services.swayosd.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    plugins = [
      # no longer using
      #inputs.hyprfocus.packages.${pkgs.system}.default
      # brokey
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    extraConfig = ''
    ${builtins.readFile ./conf/colors.conf}
    ${builtins.readFile ./conf/binds.conf}
    ${builtins.readFile ./conf/exec.conf}
    ${builtins.readFile ./conf/windowrules.conf}
    ${builtins.readFile ./hyprland.conf}
    '';
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  home.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
