{ inputs, config, pkgs, self, ... }:
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
    extraSpecialArgs = { inherit inputs self; };
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
