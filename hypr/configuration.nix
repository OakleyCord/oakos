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
      kernelPackages = pkgs.linuxPackages_latest;
      initrd.kernelModules = [ "amdgpu" ];
      kernelModules = [ "amd-pstate" ];
      kernelParams = [ "amd_pstate=guided" ];
  };


  

  networking = {
    hostName = "blerm"; # Define your hostname.
    #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


    # Enable networking
    networkmanager.enable = true;

  };


  hardware = {
      opengl.enable = true;
      opengl.driSupport = true;
      # For 32 bit applications
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
      # Enable the X11 windowing system.
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;


  services.tailscale.enable = true;
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
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
      steam
      mpv
      prismlauncher
#      armcord
      kmail
      kalendar
      vscode
      thunderbird
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

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    pkgs.flatpak
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
  ];

  services.syncthing = {
    enable = true;
    user = "oakley";
    configDir = "/home/oakley/.config/syncthing";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
