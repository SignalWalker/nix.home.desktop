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
  imports = [ ];
  config = {
    home.packages = [
      pkgs.atac
    ];
  };
  meta = { };
}
