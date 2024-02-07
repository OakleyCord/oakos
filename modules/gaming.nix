{ inputs, config, pkgs, ... }:
{
  # gaming stuffs
  programs.steam = {
    enable = true;

    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;  

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
      ];
    };
  };

  # security.wrappers.steam = {
  #   owner = "root";
  #   group = "root";
  #   source = "${pkgs.steam}/bin/steam";
  # };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
#    capSysNice = true;
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
