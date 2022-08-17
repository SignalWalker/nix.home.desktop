{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.wayland;
in {
  options.services.wayland.notifications = with lib; {
    enable = (mkEnableOption "Notification daemon") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.notifications.enable) {
    programs.mako = {
      enable = cfg.notifications.enable;
      extraConfig = readFile ./mako/config;
    };
    systemd.user.services."mako" = {
      Unit = {
        Description = "Mako notification daemon";
        Documentation = "man:mako(1)";
        PartOf = ["wayland-session.target"];
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "mako";
      };
    };
    services.wayland.startupCommands = "systemctl --user start mako.service";
  };
}
