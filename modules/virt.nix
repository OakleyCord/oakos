{ inputs, config, pkgs, ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  #virtualisation.waydroid.enable = true;

   
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
}
