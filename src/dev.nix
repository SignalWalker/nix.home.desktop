{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./dev;
}

