{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
{
  options = with lib; { };
  disabledModules = [ ];
  imports = lib.listFilePaths ./dev;
  config = {
  };
  meta = { };
}