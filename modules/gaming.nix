{ inputs, config, pkgs, ... }:
{
  # gaming stuffs
  programs.steam = {
    enable = true;

    # Open ports in the firewall
    remotePlay.openFirewall = true;  
    localNetworkGameTransfers.openFirewall = true;


    protontricks.enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;

    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamescope
      ];
    };
  };

  # security.wrappers.steam = {
  #   setuid = true;
  #   owner = "root";
  #   group = "root";
  #   source = "${pkgs.steam}/bin/steam";
  # };
  #
  # security.wrappers.bwrap = {
  #   owner = "root";
  #   group = "root";
  #   source = "${pkgs.bubblewrap}/bin/bwrap";
  #   setuid = true;
  # };

  # Fix GC Adapters
  services.udev.extraRules = ''
  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
  '';
  programs.gamemode = {
    enable = true;
    enableRenice = true;

    settings = {
      general = {
        renice = 10;
      };

      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  programs.gamescope = {
    enable = true;
    # capSysNice = true;
  };

  # fix gamescope on steam
  # nixpkgs.config.packageOverrides = pkgs: {
  #   steam = pkgs.steam.override {
  #     extraPkgs = pkgs: with pkgs; [
  #       xorg.libXcursor
  #       xorg.libXi
  #       xorg.libXinerama
  #       xorg.libXScrnSaver
  #       libpng
  #       libpulseaudio
  #       libvorbis
  #       stdenv.cc.cc.lib
  #       libkrb5
  #       keyutils
  #     ];
  #   };
  # };

  environment.systemPackages = with pkgs; [
    mangohud

    # roblox
#    vinegar

    # game modding
    r2modman
  ];
}
