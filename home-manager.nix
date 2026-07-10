{
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./src;
  config = {
    home.stateVersion = "22.11";
  };
}

