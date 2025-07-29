let
  terra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHyS/8OGr5KbM1PS7QO3qEwE1xN4JuEzI2SzkBWzks7c";
  artemis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL96LFIgKgNXAQPl9y/EtWwxBZtRatxGk535ZxDy/IU5";
  systems = [
    terra
    artemis
  ];

  ash = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFqg4NlJu7u1pcCel3EZshVwUxIfwpsh2fxhaQlLAar";
  users = [ ash ];
in
{
  "rescrobbledCfg.age".publicKeys = users ++ systems;
}
