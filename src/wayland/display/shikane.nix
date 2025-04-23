{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  shikane = config.services.shikane;
  toml = pkgs.formats.toml {};
in {
  options = with lib; {
    services.shikane = {
      enable = mkEnableOption "shikane";
      package = mkPackageOption pkgs "shikane" {};
      settings = mkOption {
        type = toml.type;
        default = {};
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf shikane.enable {
    xdg.configFile."shikane/config.toml".source = toml.generate "shikane.toml" shikane.settings;
    systemd.user.services."shikane" = {
      Unit = {
        Description = "Dynamic output configuration";
        Documentation = "man:shikane(1)";
        PartOf = [config.wayland.systemd.target];
        After = [config.wayland.systemd.target];
      };
      Service = {
        Type = "simple";
        ExecStart = "${shikane.package}/bin/shikane";
        Restart = "always";
        Slice = "service-graphical.slice";
      };
      Install = {
        WantedBy = [config.wayland.systemd.target];
      };
    };
  };
  meta = {};
}
