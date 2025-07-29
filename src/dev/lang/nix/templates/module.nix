{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = { };
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
