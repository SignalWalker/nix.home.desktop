{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  syncthing = config.services.syncthing;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    services.syncthing = {
      enable = !osConfig.services.syncthing.enable;
      extraOptions = [];
    };
    services.syncthing.tray = {
      enable = false; # osConfig.services.syncthing.enable || syncthing.enable;
      command = "syncthingtray --wait";
    };
  };
  meta = {};
}
