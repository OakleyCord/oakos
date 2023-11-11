{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  
  time.timeZone = "America/New_York";

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

  # user stuffs
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      oakley = import ../home/home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
  ];

  # required for alot of stuffs
  programs.dconf.enable = true;

  programs.zsh.enable = true;
  users.users.oakley = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "oakley";

    extraGroups = [ "networkmanager" "video" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
      firefox
      librewolf
      obs-studio
      jetbrains.idea-ultimate
      sublime-music
      kitty
      dolphin-emu
      syncthing
      # brokey :(
      # jellyfin-mpv-shim
      mpv
      prismlauncher
      kmail
      lunar-client
      kalendar
      vscode
      gnome.gnome-software
      monero-gui
      thunderbird
      # i love violating discord tos
      (pkgs.discord.override {
      # asar is broken on 0.30
#        withOpenASAR = true;
#withVencord = true;
      })

    ];
  };


  # collect my garbage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
