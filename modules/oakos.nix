{ self, lib, pkgs, config, ... }:
with lib;
let
  cfg = config.oakos;
in {
  imports = [
    ./desktop
  ];
}
