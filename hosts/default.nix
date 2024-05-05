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
    neovim
    git
    btop
    unzip
    fastfetch

    # idk why but if i put this in home manager config it just doesn't work
    home-manager
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

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/oakley/oakos";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
