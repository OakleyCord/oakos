{ inputs, config, pkgs, ... }:
{
  services.fprintd.enable = true;

  security.pam.services.sddm.fprintAuth = true;
}
