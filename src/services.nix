{
  osConfig,
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
    # services.kdeconnect = {
    #   enable = osConfig.programs.kdeconnect.enable or false;
    #   indicator = config.services.kdeconnect.enable;
    # };
    services.blueman-applet.enable = true;
    services.systembus-notify.enable = true;
    services.udiskie = {
      enable = false; # TODO :: reenable after python311Packages.keyutils is fixed
      automount = true;
      notify = true;
      tray = "auto";
    };
  };
}
