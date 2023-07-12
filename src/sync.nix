{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    services.syncthing = {
      enable = true;
      extraOptions = [];
    };
    services.syncthing.tray = {
      enable = true;
    };
  };
  meta = {};
}
