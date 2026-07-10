{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./notes;
}

