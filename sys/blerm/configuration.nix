# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, self, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ../default.nix
    ../graphical.nix
    ./hardware-configuration.nix
    ../../modules/asus.nix
    ../../modules/audio.nix
    ../../modules/gaming.nix
    ../../modules/virt.nix
    # inputs.pp-to-amd-epp.nixosModules.pp-to-amd-epp
  ];

  networking.firewall.checkReversePath = false; 

  # usb 4 still not here unsure if this is needed for that anyways
  #services.hardware.bolt.enable = true;

  # fix backlight perms
  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl*", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
  ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl*", RUN+="${pkgs.coreutils}/bin/chmod g+rw /sys/class/backlight/%k/brightness"
  '';


  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  # Bootloader.

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
      # pin to kernel version because amdgpu bug
      # amdgpu bug which screen glitches out if the resolution is not 2560x1600

      # fixed in 6.5.6
      kernelPackages = pkgs.linuxPackages_latest;

      #kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_4.override {
      #   argsOverride = rec {
      #      src = pkgs.fetchurl {
      #         url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
      #         sha256 = "zKkb6Vb+CB+PbacgNM3tlv41pQvkv7fhA+NUqiFZpnQ=";
      #      };
      #      version = "6.4.12";
      #      modDirVersion = "6.4.12";
      #   };
      #});
      initrd.kernelModules = [ "amdgpu" ];
      kernelModules = [ "amd-pstate" "v4l2loopback" ];
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      # does not work with pp-to-amd-epp
      # kernelParams = [ "amd_pstate=guided" ];
    };


    # replaced with asusd having pp-to-amd-epp like config option builtin
    # services.pp-to-amd-epp.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";


    networking = {
      hostName = "blerm"; # Define your hostname.
    # don't enable if on kde appearently
    #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networkmanager.enable = true;

  };


  services.xserver.videoDrivers = [ "amdgpu" ];

  # Add amdvlk for optional usage + opencl
  hardware.opengl = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # Use RADV by default
  environment.variables.AMD_VULKAN_ICD = "RADV";
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  # Power saving stuffs
  services.power-profiles-daemon.enable = true;


  # not using it anymore
 # programs.kdeconnect.enable = true;

 services.tailscale.enable = true;
  # gpu usage
  environment.systemPackages = with pkgs; [
    nvtop-amd
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
