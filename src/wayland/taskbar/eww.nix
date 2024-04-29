{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  taskbar = config.services.taskbar;
  eww = config.programs.eww;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkIf taskbar.enable {
    programs.eww = {
      enable = true;
      package = pkgs.eww;
      configDir = ./eww;
    };
    systemd.user.services.${taskbar.systemd.serviceName} = {
      Service = {
        Type = "simple";
        Environment = ["PATH=/run/current-system/sw/bin:${pkgs.playerctl}/bin"];
        ExecStart = "${eww.package}/bin/eww daemon --no-daemonize --force-wayland";
      };
    };
  };
  meta = {};
}
