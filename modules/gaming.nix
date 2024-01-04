{ inputs, config, pkgs, ... }:
{
  # gaming stuffs
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };
  programs.gamemode.enable = true;
  # fix gamescope on steam
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
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
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope

    # roblox
    vinegar
  ];
}
