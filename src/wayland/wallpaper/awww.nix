{
  config,
  pkgs,
  lib,
  ...
}:
let
  awww = config.services.awww;
  wallmaster = config.services.wallmaster;
in
{
  options =

    let
      inherit (lib) mkEnableOption mkOption types;
    in
    {
      services.wallmaster = {
        enable = (mkEnableOption "wallmaster") // {
          default = awww.enable;
        };
        package = mkOption {
          type = types.package;
        };
        interval = mkOption {
          type = types.str;
          default = "30m";
        };
      };
      services.awww = {
        enable = mkEnableOption "awww wallpaper daemon";
        package = mkOption {
          type = types.package;
          default = pkgs.awww;
        };
        systemd = {
          enable = mkEnableOption "awww systemd integration";
          target = mkOption {
            type = types.str;
            default = config.wayland.systemd.target;
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
    };
  imports = [ ];
  disabledModules = [ "services/awww.nix" ];
  config = lib.mkIf awww.enable {
    home.packages = [
      awww.package
      wallmaster.package
    ];
    systemd.user.services = lib.mkIf awww.systemd.enable {
      "awww" = {
        Unit = {
          Description = "awww wallpaper daemon";
          Documentation = "man:awww(1)";
          PartOf = [ awww.systemd.target ];
          After = [ awww.systemd.target ];
        };
        Install = {
          WantedBy = [ awww.systemd.target ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${awww.package}/bin/awww-daemon --quiet --no-cache";
          ExecStop = "${awww.package}/bin/awww kill";
          Slice = "background-graphical.slice";
          Restart = "on-failure";
        };
      };
      "wallmaster-randomize" = {
        Unit = {
          PartOf = [ awww.systemd.target ];
          Requires = [ "awww.service" ];
          After = [ "awww.service" ];
        };
        Service = {
          Environment = [
            "AWWW_TRANSITION_FPS=${toString awww.img.fps}"
            "AWWW_TRANSITION_STEP=${toString awww.img.step}"
            "AWWW_TRANSITION_DURATION=1"
          ];
          Type = "oneshot";
          ExecStart = "${wallmaster.package}/bin/wallmaster --bin-path ${awww.package}/bin/awww randomize ${awww.img.path}";
        };
      };
    };
    systemd.user.timers = lib.mkIf awww.systemd.enable {
      "wallmaster-randomize" = {
        Unit = {
          Description = "wallpaper randomizer";
          PartOf = [ awww.systemd.target ];
          After = [ "awww.service" ];
        };
        Install = {
          WantedBy = [ "awww.service" ];
        };
        Timer = {
          OnUnitActiveSec = wallmaster.interval;
          OnActiveSec = "0s";
        };
      };
    };
  };
}
