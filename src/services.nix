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
    services.notify-failure.enable = true;
    services.kdeconnect.indicator = false;
    services.blueman-applet.enable = true;
  };
}
