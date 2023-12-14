{ inputs, config, pkgs, ... }:
{

  home.file = {
    # config from https://github.com/rose-pine/swaync
    ".config/swaync/config.json".source = ./config.json;  
    ".config/swaync/style.css".source = ./style.css;  
  };
}
