{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wln = config.desktop.wayland;
in {
  options.desktop.wayland.notifications = with lib; {
    enable = (mkEnableOption "Notification daemon") // {default = true;};
  };
  imports = lib.signal.fs.path.listFilePaths ./notifications;
  config = lib.mkIf wln.notifications.enable {
    services.dunst = {
      enable = false;
    };
    services.mako.enable = !config.services.dunst.enable;
  };
}
