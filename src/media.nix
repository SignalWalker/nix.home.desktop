{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
in
{
  options = with lib; { };
  disabledModules = [ ];
  imports = lib.signal.fs.path.listFilePaths ./media;
  config = {
  };
  meta = { };
}
