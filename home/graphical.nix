{ inputs, config, pkgs, self, ... }:
{

  imports = [
    ./firefox/firefox.nix
    ./mpv/mpv.nix
    ./hypr/hyprland.nix
  ];

  # theming
  gtk = {
    enable = true;
    theme.name = "rose-pine";
    theme.package = pkgs.rose-pine-gtk-theme;
    cursorTheme.name = "Catppuccin-Macchiato-Dark";
    cursorTheme.package = pkgs.catppuccin-cursors;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
    font.name = "source-code-pro";
    font.package = pkgs.nerdfonts;
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
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
    # rich presence
    #arrpc = {
    #  Unit.Description = "Discord rich presence";
    #  Install.WantedBy = [ "graphical-session.target" ];
    #  Unit.Wants = [ "graphical-session.target" ];
    #  Unit.After = [ "graphical-session.target" ];
    #  Service = {
    #    ExecStart = "${pkgs.arrpc}/bin/arrpc";
    #  };
    #};

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

    # file manager
    cinnamon.nemo

    # compressed files
    libsForQt5.ark

    # discord
    vesktop

    obs-studio
#    jetbrains.idea-ultimate
    dolphin-emu
    # not brokey :)
    jellyfin-mpv-shim
    prismlauncher
    lunar-client
    vscode
    gnome.gnome-software
    monero-gui
    thunderbird

    # i need this assignment done
    libreoffice

    # for doing some audio stuffs
    ffmpeg
    audacity
    kid3
  ];
}
