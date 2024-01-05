# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, self, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t420
      ./hardware-configuration.nix
      ../../modules/audio.nix
      ../graphical.nix
      ../default.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = [ "i915" ];

  # gpu usage
  environment.systemPackages = with pkgs; [
    nvtop-intel
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

