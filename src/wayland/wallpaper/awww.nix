{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  cfg = config.services.awww;
  awww-randomize = ./awww/awww-randomize;
in
{
  options.services.awww = with lib; {
    enable = mkEnableOption "awww wallpaper daemon";
    package = mkOption {
      type = types.package;
      default = pkgs.awww;
    };
    randomizeScript = mkOption {
      type = types.path;
      readOnly = true;
      default = awww-randomize;
    };
    systemd = {
      enable = mkEnableOption "awww systemd integration";
      target = mkOption {
        type = types.str;
        default = config.wayland.systemd.target;
      };
      randomize = {
        interval = mkOption {
          type = types.str;
          default = "30m";
        };
      };
    };
    img = {
      fps = mkOption {
        type = types.int;
        default = 30;
      };
      step = mkOption {
        type = types.int;
        default = 85;
      };
      path = mkOption {
        type = types.str;
      };
    };
  };
  imports = [ ];
  disabledModules = [ "services/awww.nix" ];
  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
    xdg.binFile."awww-randomize" = {
      executable = true;
      source = awww-randomize;
    };
    systemd.user.services = lib.mkIf cfg.systemd.enable {
      "awww" = {
        Unit = {
          Description = "awww wallpaper daemon";
          Documentation = "man:awww(1)";
          PartOf = [ cfg.systemd.target ];
          After = [ cfg.systemd.target ];
        };
        Install = {
          WantedBy = [ cfg.systemd.target ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${cfg.package}/bin/awww-daemon --quiet --no-cache";
          ExecStop = "${cfg.package}/bin/awww kill";
          Slice = "background-graphical.slice";
          Restart = "on-failure";
        };
      };
      "awww-randomize" = {
        Unit = {
          PartOf = [ cfg.systemd.target ];
          Requires = [ "awww.service" ];
          After = [ "awww.service" ];
        };
        Service = {
          Environment = [
            "AWWW_TRANSITION_FPS=${toString cfg.img.fps}"
            "AWWW_TRANSITION_STEP=${toString cfg.img.step}"
            "AWWW_TRANSITION_DURATION=1"
          ];
          Type = "oneshot";
          ExecStart =
            let
              py = pkgs.python311.withPackages (
                ps: with ps; [
                  pillow
                ]
              );
            in
            "${py}/bin/python3 ${cfg.randomizeScript} --bin-path ${cfg.package}/bin/awww --animated --max-variance=0.1 ${cfg.img.path}";
        };
      };
    };
    systemd.user.timers = lib.mkIf cfg.systemd.enable {
      "awww-randomize" = {
        Unit = {
          Description = "wallpaper randomizer";
          PartOf = [ cfg.systemd.target ];
          After = [ "awww.service" ];
        };
        Install = {
          WantedBy = [ "awww.service" ];
        };
        Timer = {
          OnUnitActiveSec = cfg.systemd.randomize.interval;
          OnActiveSec = "0s";
        };
      };
    };
  };
}
