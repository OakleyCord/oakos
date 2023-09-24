# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  networking.firewall.checkReversePath = false; 

  services.hardware.bolt.enable = true;


  # bluetooth
  hardware.bluetooth.enable = true;

  # Bootloader.
  
  boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      # pin to kernel version because amdgpu bug
      # amdgpu bug which screen glitches out if the resolution is not 2560x1600
      kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_4.override {
         argsOverride = rec {
            src = pkgs.fetchurl {
               url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
               sha256 = "zKkb6Vb+CB+PbacgNM3tlv41pQvkv7fhA+NUqiFZpnQ=";
            };
            version = "6.4.12";
            modDirVersion = "6.4.12";

         };
      });
      initrd.kernelModules = [ "amdgpu" ];
      kernelModules = [ "amd-pstate" "v4l2loopback" ];
      extraModulePackages = with config.boot.kernelPackages; [
           v4l2loopback
      ];
      kernelParams = [ "amd_pstate=guided" ];
  };


  

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


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };



  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };


  services = {
      xserver.enable = true;
      xserver.videoDrivers = [ "amdgpu" ];



      # Asus stuff
      asusd = {
          enable = true;
          enableUserService = true;
      };
      supergfxd.enable = true;



      # flatpak
      flatpak.enable = true;



      # Enable the KDE Plasma Desktop Environment.
      xserver.displayManager.sddm.enable = true;
      xserver.desktopManager.plasma5.enable = true;
      # set default for sddm
      xserver.displayManager.defaultSession = "plasmawayland";
  };

  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };
  fonts.fontDir.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;


  services.tailscale.enable = true;
  programs.zsh.enable = true;

  programs.steam.enable = true;

  users.users.oakley = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "oakley";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      librewolf
      obs-studio
      jetbrains.idea-ultimate
      sublime-music
      kitty
      dolphin-emu
      syncthing
      freshfetch
      # brokey :(
      # jellyfin-mpv-shim
      mpv
      prismlauncher
      kmail
      kalendar
      vscode
      mangohud
      thunderbird
      # i love violating discord tos
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })

    ];
  };



  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };


  # allow docker
  virtualisation.docker.enable = true;


  # We love virtualisation
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  
 
  environment.systemPackages = with pkgs; [
    neovim
    flatpak
    git
    btop
    keychain
    virt-manager
    unzip
    pkgs.zsh
    asusctl
    gamescope
    tailscale
    lf
    networkmanagerapplet
    home-manager
    nvtop-amd
    gradle
    nixpkgs-fmt
  ];

  services.syncthing = {
    enable = true;
    user = "oakley";
    configDir = "/home/oakley/.config/syncthing";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
