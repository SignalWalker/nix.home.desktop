{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wayland = config.desktop.wayland;

  taskbar = config.services.taskbar;
in {
  options = with lib; {
    services.taskbar = {
      enable = (mkEnableOption "task/status bar") // {default = true;};
      systemd = {
        serviceName = mkOption {
          type = types.str;
          default = "wayland-taskbar";
          readOnly = true;
        };
      };
    };
    programs.waybar.src = mkOption {
      type = types.path;
    };
    desktop.wayland.taskbar = {
      enable = mkEnableOption "task/status bar";
    };
  };
  imports = lib.listFilePaths ./taskbar;
  config = lib.mkIf taskbar.enable {
    systemd.user.services.${taskbar.systemd.serviceName} = {
      Unit = {
        Description = "Taskbar for Wayland compositors.";
        PartOf = [config.wayland.systemd.target];
        Before = ["tray.target"];
        BindsTo = ["tray.target"];
        After = [config.wayland.systemd.target];
      };
      Service.Slice = "background-graphical.slice";
      # service config provided by enabled bar
      Install = {
        WantedBy = [config.wayland.systemd.target];
        RequiredBy = ["tray.target"];
      };
    };
  };
}