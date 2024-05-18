{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wayland = config.desktop.wayland;
  kanshi = config.services.kanshi;
in {
  options = with lib; {
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf wayland.enable {
    home.packages = with pkgs; [
      wlay
    ];
    services.kanshi = {
      enable = false; # so that the config file can be written to by wlay
      systemdTarget = wayland.systemd.target;
    };
    systemd.user.services."kanshi" = lib.mkIf (!kanshi.enable) {
      Unit = {
        Description = "Dynamic output configuration";
        Documentation = "man:kanshi(1)";
        PartOf = [kanshi.systemdTarget];
        Requires = [kanshi.systemdTarget];
        After = [kanshi.systemdTarget];
      };
      Service = {
        Type = "simple";
        ExecStart = "${kanshi.package}/bin/kanshi";
        Restart = "always";
      };
      Install = {
        WantedBy = [kanshi.systemdTarget];
      };
    };
  };
  meta = {};
}