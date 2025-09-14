{
  config,
  pkgs,
  lib,
  ...
}:
let
  qs = config.programs.quickshell;
  taskbar = config.services.taskbar;
in
{
  options = {
    programs.quickshell = {
      mutableConfigDir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "/home/ash/projects/nix/home/desktop/src/wayland/taskbar/quickshell";
      };
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf (taskbar.enable && (taskbar.type == "quickshell")) (
    lib.mkMerge [
      {
        programs.quickshell = {
          enable = true;
          # activeConfig = "taskbar";
          systemd.enable = false;
        };
        systemd.user.services.${taskbar.systemd.serviceName} = {
          Service = {
            ExecStart =
              lib.getExe qs.package + (if qs.activeConfig == null then "" else " --config ${qs.activeConfig}");
            Restart = "on-failure";
          };
        };
      }
      (lib.mkIf (qs.mutableConfigDir == null) {
        xdg.configFile."quickshell".source = ./quickshell;
      })
      (lib.mkIf (qs.mutableConfigDir != null) {
        home.activation."make-quickshell-cfg-symlink" =
          let
            target = qs.mutableConfigDir;
            link = "${config.xdg.configHome}/quickshell";
          in
          (lib.hm.dag.entryAfter [ "WriteBoundary" ] ''
            run rm $VERBOSE_ARG -- ${link} || true
            run ln -s $VERBOSE_ARG -T ${target} ${link}
          '');
      })
    ]
  );
  meta = { };
}
