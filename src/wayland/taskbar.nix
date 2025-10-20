{
  config,
  lib,
  ...
}:
let
  taskbar = config.services.taskbar;
in
{
  options = {
    services.taskbar = {
      enable = (lib.mkEnableOption "task/status bar") // {
        default = true;
      };
      type = lib.mkOption {
        type = lib.types.enum [
          "eww"
          "quickshell"
        ];
        default = "quickshell";
      };
      systemd = {
        serviceName = lib.mkOption {
          type = lib.types.str;
          default = "wayland-taskbar";
          readOnly = true;
        };
      };
    };
    programs.waybar.src = lib.mkOption {
      type = lib.types.path;
    };
  };
  imports = lib.listFilePaths ./taskbar;
  config = lib.mkIf taskbar.enable {
    systemd.user.services.${taskbar.systemd.serviceName} = {
      Unit = {
        Description = "Taskbar for Wayland compositors.";
        PartOf = [ config.wayland.systemd.target ];
        Before = [ "tray.target" ];
        BindsTo = [ "tray.target" ];
        After = [ config.wayland.systemd.target ];
      };
      Service.Slice = "background-graphical.slice"; # provided by UWSM
      # service config provided by enabled bar
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
        RequiredBy = [ "tray.target" ];
      };
    };
  };
}
