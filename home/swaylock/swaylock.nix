{ inputs, config, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package =  pkgs.swaylock-effects;
    settings =  {

      color = "#191724";

      layout-bg-color = "#00000000";
      layout-border-color = "#00000000";
      layout-text-color = "#e0def4";

      text-color = "#e0def4";
#      text-clear-color = "#9ccfd8";
#      text-caps-lock-color = "#f6c177";
#      text-ver-color = "#c4a7e7";
#      text-wrong-color = "#eb6f92";

      bs-hl-color = "#19172466";
      key-hl-color = "#31748f";
      caps-lock-bs-hl-color = "#19172466";
      caps-lock-key-hl-color = "#f6c177";

      separator-color = "#00000000";

      inside-color = "#31748f55";
      inside-clear-color = "#9ccfd855";
      inside-caps-lock-color = "#f6c17755";
      inside-ver-color = "#c4a7e755";
      inside-wrong-color = "#eb6f9255";

      line-color = "#31748f11";
      line-clear-color = "#9ccfd811";
      line-caps-lock-color = "#f6c17711";
      line-ver-color = "#c4a7e711";
      line-wrong-color = "#eb6f9211";
      ring-color = "#31748faa";
      ring-clear-color = "#9ccfd8aa";
      ring-caps-lock-color = "#f6c177aa";
      ring-ver-color = "#c4a7e7aa";
      ring-wrong-color = "#eb6f92aa";

      effect-blur = "5x4";
      fade-in = "0.5";
      clock = true;
      screenshots = true;
      indicator = true;

    };
  };
}
