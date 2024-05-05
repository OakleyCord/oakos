{ inputs, config, pkgs, self, ... }:
{

  imports = [
    ./firefox/firefox.nix
    ./mpv/mpv.nix
    # TODO: make it so i can chose desktop environment in hosts configs
    ./hypr/hyprland.nix
  ];

  # theming
  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    gtk.enable = true;
    x11.enable = true;
  };
  gtk = {
    enable = true;
    theme.name = "rose-pine";
    theme.package = pkgs.rose-pine-gtk-theme;
    iconTheme.name = "rose-pine";
    iconTheme.package = pkgs.rose-pine-icon-theme;
    font.name = "source-code-pro";
    font.package = (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; });
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovim-wrapper.desktop" ];
    "inode/directory" = [ "nemo.desktop" ];
    "image/*" = [ "imv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "text/html" = [ "firefox.desktop "];
  };

  systemd.user.services = {
    # polkit 
    polkit-gnome-agent = {
      Unit.Description = "polkit-gnome-authentication-agent-1";
      Install.WantedBy = [ "graphical-session.target" ];
      Unit.Wants = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  programs.kitty = {
    enable = true;
    theme = "Rosé Pine";

    settings = {
      background_opacity = "0.85";
      confirm_os_window_close = "0";
    };
  };

  home.packages = with pkgs; [
    # audio control
    pavucontrol

    # image viewer
    imv

    # notify-send
    libnotify

    # compressed files
    libsForQt5.ark

    # discord
    vesktop

    obs-studio
    dolphin-emu
    # not brokey :)
    jellyfin-mpv-shim
    prismlauncher
    monero-gui
    thunderbird

    # i need this assignment done
    libreoffice

    # for doing some audio stuffs
    ffmpeg
    audacity
    kid3

    # neovim graphical
    neovide
  ];
}
