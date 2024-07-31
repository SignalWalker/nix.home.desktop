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
  options = with lib; {
    programs.eww = {
      enable = mkEnableOption "eww widgets";
      package = mkPackageOption pkgs "eww" {};
      configDir = mkOption {
        type = types.path;
        readOnly = true;
        default = ./eww;
      };
      mutableConfigDir = mkOption {
        type = types.nullOr types.str;
        description = "If set, instead of linking to eww.configDir, link to the provided path.";
        default = null;
      };
    };
  };
  disabledModules = ["programs/eww.nix"];
  imports = [];
  config = lib.mkIf taskbar.enable (lib.mkMerge [
    {
      warnings = ["using custom eww module"];

      home.packages = [eww.package];

      programs.eww = {
        enable = true;
        # package = pkgs.eww;
        # configDir = ./eww;
      };

      systemd.user.services.${taskbar.systemd.serviceName} = lib.mkIf eww.enable {
        Service = let
          python = pkgs.python311.withPackages (ps:
            with ps; [
              pygobject3
              i3ipc
            ]);
          path = std.makeBinPath [
            python
            pkgs.playerctl
            config.home.profileDirectory
            "/run/current-system/sw"
          ];
          typelibPath = std.makeSearchPathOutput "lib" "lib/girepository-1.0" [
            pkgs.glib
            pkgs.playerctl
          ];
        in {
          Type = "simple";
          Environment = [
            "PATH=${path}"
            "GI_TYPELIB_PATH=${typelibPath}"
          ];
          ExecStart = "${eww.package}/bin/eww daemon --no-daemonize --force-wayland";
          ExecStartPost = "${eww.package}/bin/eww open main";
        };
      };
    }

    (lib.mkIf (eww.mutableConfigDir != null) {
      home.activation."make-eww-cfg-symlink" = let
        target = eww.mutableConfigDir;
        link = "${config.xdg.configHome}/eww";
      in (lib.hm.dag.entryAfter ["WriteBoundary"] ''
        run rm $VERBOSE_ARG -- ${link} || true
        run ln -s $VERBOSE_ARG -T ${target} ${link}
      '');
    })

    # (lib.mkIf (eww.mutableConfigDir == null) {
    #   xdg.configFile."eww".source = eww.configDir;
    # })
  ]);
  meta = {};
}
