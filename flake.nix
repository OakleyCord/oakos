{
  description = "Oakley's NixOS Config";
  
  inputs = {

    # Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Managing home directory & config
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # Neovim config
    oakvim = {
      url = "git+https://git.oak.li/oakley/oakvim";
#      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository, mostly used for Firefox extentions
    nur.url = github:nix-community/NUR;

    # To help with some theming but I think I could replace this 
    # TODO: remove or replace nix-colors
    nix-colors.url = "github:Misterio77/nix-colors";

    # WSL support, but barely used probably will remove 
    # TODO: remove WSL support
    nixos-wsl = {
      url = github:nix-community/NixOS-WSL;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Settings for specific hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";   

    # Secret management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # Small optimization to save a small amount of space on linux
      inputs.darwin.follows = "";
    };

    # runner
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland stuffs
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.35.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprfocus = {
      url = "github:VortexCoyote/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      # latest is brokey
      url = "github:Duckonaut/split-monitor-workspaces?ref=2b1abdbf9e9de9ee660540167c8f51903fa3d959";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {self, nixpkgs, home-manager, ...}@inputs:
  let
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };

  in
  {
    # added this because i wanted a newer version of r2modman for lethal company, seems to not work on wayland but will run under gamescope
    packages.${system} =  {
      sddm-rose-pine = pkgs.callPackage ./packages/sddm-rose-pine.nix {};
    };
    nixosConfigurations = {
      blerm = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system self; };

        modules = [
          ./hosts/blerm/configuration.nix
        ];
      };
      thinkpaw = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system self; };

        modules = [
          ./hosts/thinkpaw/configuration.nix
        ];
      };
      mebep = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system self; };
       
        modules = [
           ./hosts/mebep/configuration.nix
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system self; };
        modules = [
          ./hosts/wsl/configuration.nix
        ];
      };
    };
    homeConfigurations = {
      oakley = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs system self; };

        modules = [ ./home/home.nix ];
      };
    };
  };

}
