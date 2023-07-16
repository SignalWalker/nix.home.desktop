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
  imports = [];
  config = {
    services.check-battery.enable = true;
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
    services.blueman-applet.enable = true;
    services.systembus-notify.enable = true;
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };
}
