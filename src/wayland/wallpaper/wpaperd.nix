{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  tomlFormat = pkgs.formats.toml {};
in {
  options.services.wpaperd = with lib; {
    enable = mkEnableOption "wpaperd wallpaper daemon";
    package = mkOption {
      type = types.package;
    };
    settings = mkOption {
      type = tomlFormat.type;
      default = {};
    };
    systemd = {
      enable = mkEnableOption "wpaperd systemd integration";
      target = mkOption {
        type = types.str;
        default = "wayland-session.target";
      };
    };
  };
  imports = [];
  config = let cfg = config.services.wpaperd; in lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
    ];
    xdg.configFile."wpaperd/output.conf" = {
      source = tomlFormat.generate "wpaperd-config" cfg.settings;
    };
    systemd.user.services = lib.mkIf cfg.systemd.enable {
      "wpaperd" = {
        Unit = {
          Description = "wpaperd wallpaper daemon";
          Documentation = "man:wpaperd(1)";
          PartOf = [ cfg.systemd.target ];
        };
        Install = {
          WantedBy = [ cfg.systemd.target ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${cfg.package}/bin/wpaperd --no-daemon";
        };
      };
    };
  };
}
