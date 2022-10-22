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
          Type = "simple";
          ExecStart = "${cfg.package}/bin/swww init";
          ExecStartPost = ["${cfg.package}/bin/swww img ${cfg.img.path}"];
        };
      };
    };
  };
}
