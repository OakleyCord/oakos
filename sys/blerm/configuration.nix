# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, self, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ../default.nix
    ./hardware-configuration.nix
    ../../modules/asus.nix
    ../../modules/audio.nix
    ../../modules/gaming.nix
    ../../modules/virt.nix
    inputs.pp-to-amd-epp.nixosModules.pp-to-amd-epp
  ];


  security.pam.services.sddm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  networking.firewall.checkReversePath = false; 

  services.hardware.bolt.enable = true;

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


    services.pp-to-amd-epp.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";


    networking = {
      hostName = "blerm"; # Define your hostname.
    # don't enable if on kde appearently
    #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


    # Enable networking
    networkmanager.enable = true;

  };


  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;

  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services = {
    xserver.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];

    # flatpak
    flatpak.enable = true;
    # Enable the KDE Plasma Desktop Environment.
    xserver.displayManager.sddm.enable = true;
    xserver.desktopManager.plasma5.enable = true;
    # set default for sddm
    xserver.displayManager.defaultSession = "hyprland";
  };

  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };
  fonts.fontDir.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };


  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;


  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    flatpak
    git
    btop
    unzip
    wl-clipboard
    pkgs.zsh
    asusctl
    gamescope
    tailscale
    lf
    networkmanagerapplet
    nvtop-amd
    gradle
    krita
    nixpkgs-fmt
    fastfetch
    eww-wayland
    swww
    rofi-wayland
    dunst

    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    })
    )
    #needed for some scripts
    jq
    python311
    socat
  ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
