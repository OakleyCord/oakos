let
  # pub ssh keys of my user on these systems

  blerm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUnjY+bgEcNa4PCpyUKWuGAHUaoa2uiSwoM4v75umVQ oakley@blerm";
  wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFs421iS6hRRFSOq+5xffzXQO1ic4FCRUrpmNnU+m7ov oakley@nixos";
  systems = [ blerm wsl ];
in {
    "wakatime.cfg.age".publicKeys = systems;
}
