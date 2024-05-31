{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.desktop.wayland;
in {
  options.desktop.wayland.notifications = with lib; {
    enable = (mkEnableOption "Notification daemon") // {default = true;};
  };
  imports = lib.signal.fs.path.listFilePaths ./notifications;
  config = lib.mkIf (cfg.enable && cfg.notifications.enable) {
    services.dunst = {
      enable = true;
    };
    services.mako.enable = !config.services.dunst.enable;
  };
}

