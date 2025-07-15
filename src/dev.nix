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
  imports = lib.signal.fs.path.listFilePaths ./dev;
  config = {
  };
  meta = { };
}
