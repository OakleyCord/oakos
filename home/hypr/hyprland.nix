{ inputs, config, pkgs, ... }:
{
  imports = [
    ../waybar/waybar.nix
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

    # the watchamacallit
    rofi-wayland

    # notifications (for now)
    dunst

    # wallpaper
    swww


    # networking :3
    networkmanagerapplet

    # clipboard
    wl-clipboard


    # widgets (unused)
    eww-wayland
  ];

  home.file = {
    ".config/hypr/scripts" = {
      source = ./scripts;
      recursive = true;
      executable = true;
    };
  };

  # bluetooth :]
  services.blueman-applet.enable = true;

  # on screen display
  services.swayosd.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;



    plugins = [
      inputs.hyprfocus.packages.${pkgs.system}.default
      #brokey
      #inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    extraConfig = ''
    ${builtins.readFile ./conf/colors.conf}
    ${builtins.readFile ./conf/binds.conf}
    ${builtins.readFile ./conf/exec.conf}
    ${builtins.readFile ./conf/monitors.conf}
    ${builtins.readFile ./conf/windowrules.conf}
    ${builtins.readFile ./hyprland.conf}
    '';
    # Whether to enable hyprland-session.target on hyprland startup
    systemd = {
      enable = true;
      variables = ["-all"];
    };
  };

  home.sessionVariables = {
    # fix gamescope on steam
    # TODO: move to gaming.nix module
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    #SDL_VIDEODRIVER = "x11";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
