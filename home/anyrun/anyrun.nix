{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      layer = "overlay";
      hidePluginInfo = true;
    };

    extraCss = ''
    window {
      background: transparent;
    }
    '';
  };
}
