{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  sway = config.wayland.windowManager.sway;
  swayPkg = if sway.package == null then osConfig.programs.sway.package else sway.package;
in
{
  config = {
    programs.app2unit.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      package = if osConfig.programs.sway.enable or false then null else pkgs.sway;
      systemd = {
        enable = false; # handled by UWSM
        dbusImplementation = osConfig.services.dbus.implementation;
      };
      config = {
        modifier = "Mod3";
        terminal = "kitty";
      };
    };
  };
  meta = { };
}
