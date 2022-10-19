{ config
, pkgs
, lib
, ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
in
{
  options.signal.desktop.wayland.notifications = with lib; {
    enable = (mkEnableOption "Notification daemon") // { default = true; };
  };
  imports = lib.signal.fs.path.listFilePaths ./notifications;
  config = lib.mkIf (cfg.enable && cfg.notifications.enable) {
    programs.mako = {
      enable = cfg.notifications.enable;
      extraConfig = readFile ./mako/config;
    };
    systemd.user.services."mako" = {
      Unit = {
        Description = "Mako notification daemon";
        Documentation = "man:mako(1)";
        PartOf = [ "wayland-session.target" ];
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "mako";
      };
    };
  };
}
