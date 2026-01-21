{
  osConfig,
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
    services.kdeconnect = {
      enable = osConfig.programs.kdeconnect.enable or false;
      indicator = config.services.kdeconnect.enable;
    };
  };
  meta = { };
}
