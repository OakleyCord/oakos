let
  # pub ssh keys of my user on these systems

  blerm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUnjY+bgEcNa4PCpyUKWuGAHUaoa2uiSwoM4v75umVQ oakley@blerm";
  thinkpaw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmY1MlEER1uoCT5em+iGiOZ5OUIXw9alXcrorq/HP+W oakley@thinkpaw";
  wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFs421iS6hRRFSOq+5xffzXQO1ic4FCRUrpmNnU+m7ov oakley@nixos";
  mebep = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6wSzCL+Uc+KIlPUV5NRYeNE9vO4dMOtoDq3LLma2cF oakley@mebep";
  systems = [ blerm thinkpaw wsl mebep ];
in {
    "wakatime.cfg.age".publicKeys = systems;
}
