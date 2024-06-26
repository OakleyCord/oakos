# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, self, ... }:
{
  imports = [ # Include the results of the hardware scan.
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t420
      ./hardware-configuration.nix
      ../../modules/audio.nix
      ../../modules/fprint.nix
      ../../modules/gaming.nix
      ../../modules/oakos.nix
      ../default.nix
  ];

  oakos.desktop = {
    enable = true;
    hyprland.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.xserver.videoDrivers = [ "i915" ];

  hardware.opengl = {
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  # gpu usage
  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
  ];

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  networking.hostName = "thinkpaw"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


  system.stateVersion = "23.11"; # Did you read the comment?

}

