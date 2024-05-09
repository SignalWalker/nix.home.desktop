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
  # imports = lib.signal.fs.path.listFilePaths ./services;
  config = {
    services.watch-battery.enable = true;
    # services.kdeconnect = {
    #   enable = osConfig.programs.kdeconnect.enable or false;
    #   indicator = config.services.kdeconnect.enable;
    # };
    # services.blueman-applet.enable = true;
    services.systembus-notify.enable = true;
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };
}
