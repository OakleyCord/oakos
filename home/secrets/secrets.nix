let
  # pub ssh keys of my user on these systems

  blerm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUnjY+bgEcNa4PCpyUKWuGAHUaoa2uiSwoM4v75umVQ oakley@blerm";
  systems = [ blerm ];
in {
    "wakatime.cfg.age".publicKeys = systems;
}
