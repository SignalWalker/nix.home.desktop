{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wln = config.signal.desktop.wayland;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkIf wln.enable {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      tray = true;
      settings = {};
    };
  };
  meta = {};
}
