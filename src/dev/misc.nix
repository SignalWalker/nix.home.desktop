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
    home.packages = attrValues {
      inherit (pkgs)
        # debug
        strace
        ;
    };
  };
  meta = { };
}
