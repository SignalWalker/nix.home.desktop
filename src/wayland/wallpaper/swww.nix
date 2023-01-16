{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  tomlFormat = pkgs.formats.toml {};
  cfg = config.services.swww;
  swww-randomize = ./swww/swww-randomize;
in {
  options.services.swww = with lib; {
    enable = mkEnableOption "swww wallpaper daemon";
    package = mkOption {
      type = types.package;
    };
    systemd = {
      enable = mkEnableOption "swww systemd integration";
      target = mkOption {
        type = types.str;
        default = "wayland-session.target";
      };
    };
    img = {
      fps = mkOption {
        type = types.int;
        default = 120;
      };
      step = mkOption {
        type = types.int;
        default = 90;
      };
      path = mkOption {
        type = types.str;
      };
    };
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
    ];
    systemd.user.services = lib.mkIf cfg.systemd.enable {
      "swww" = {
        Unit = {
          Description = "swww wallpaper daemon";
          Documentation = "man:swww(1)";
          PartOf = [cfg.systemd.target];
        };
        Install = {
          WantedBy = [cfg.systemd.target];
        };
        Service = {
          Environment = ["SWWW_TRANSITION_FPS=${toString cfg.img.fps}" "SWWW_TRANSITION_STEP=${toString cfg.img.step}"];
          Type = "simple";
          ExecStart = "${cfg.package}/bin/swww init --no-daemon";
          ExecStartPost = ["${swww-randomize} ${cfg.img.path}"];
        };
      };
    };
  };
}
