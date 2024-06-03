{ pkgs, ... }:
{

  programs.rog-control-center = {
    enable = true; 
  };



  # Asus stuff
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  systemd.services.supergfxd.path = [ pkgs.pciutils ];
  services.supergfxd.enable = true;
}
