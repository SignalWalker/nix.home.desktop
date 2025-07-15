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
    warnings = [ "warning" ];
    assertions = [
      {
        assertion = false;
        message = "assertion";
      }
    ];
  };
  meta = { };
}
