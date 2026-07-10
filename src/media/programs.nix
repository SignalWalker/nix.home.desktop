{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./programs;
  config = {
  };
}
