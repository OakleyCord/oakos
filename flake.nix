{
  description = "Oakley's NixOS Config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:Misterio77/nix-colors";

    # wsl support
    nixos-wsl = {
      url = github:nix-community/NixOS-WSL;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pp-to-amd-epp = {
      url = github:OakleyCord/pp-to-amd-epp;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    
    # secret management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # small optimization to save a small amount of space on linux
      inputs.darwin.follows = "";
    };

    # hyprland stuffs
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.32.0";
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

    nixosConfigurations = {
      blerm = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };

        modules = [
          ./sys/blerm/configuration.nix
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./sys/wsl/configuration.nix
        ];
      };
    };
  };

}
