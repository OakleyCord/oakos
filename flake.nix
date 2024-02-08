{
  description = "Oakley's NixOS Config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = github:nix-community/NUR;

    nix-colors.url = "github:Misterio77/nix-colors";

    # wsl support
    nixos-wsl = {
      url = github:nix-community/NixOS-WSL;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # pp-to-amd-epp = {
    #   url = github:OakleyCord/pp-to-amd-epp;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # settings for specific hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";   

    # secret management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # small optimization to save a small amount of space on linux
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
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {self, nixpkgs, ...}@inputs:
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
          ./sys/blerm/configuration.nix
        ];
      };
      thinkpaw = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system self; };

        modules = [
          ./sys/thinkpaw/configuration.nix
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system self; };
        modules = [
          ./sys/wsl/configuration.nix
        ];
      };
    };
  };

}
