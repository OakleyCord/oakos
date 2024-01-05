{ inputs, config, pkgs, self, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.agenix.homeManagerModules.age
    ./nvim/nvim.nix
    ./graphical.nix
  ];

  # fix agenix user service not restarting on switching configs
  # https://github.com/ryantm/agenix/issues/50#issuecomment-1729135009
  # MAY CAUSE WEIRD SIDE EFFECTS
  systemd.user.startServices = "sd-switch";

  # wakatime comfig
  age.secrets.wakatime-cfg = {
    file = ./secrets/wakatime.cfg.age;
    path = ".wakatime.cfg";
  };


  home.username = "oakley";
  home.homeDirectory = "/home/oakley";

  home.packages = with pkgs; [
    killall

    #needed for some scripts
    jq
    python311
    socat

    # fetch
    pfetch
  ];

  # nix-color theme
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;

  programs.git = {
    enable = true;
    userName = "oakley";
    userEmail = "oakleycord@proton.me";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    initExtra = ''
    pfetch
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      username = {
        style_user = "white bold";
        style_root = "black bold";
        format = "[$user]($style)";
        disabled = false;
        show_always = true; 
      };
      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol](bold blue) on [$hostname](bold red) ";
        disabled = false;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "22.11"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
