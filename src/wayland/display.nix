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
      nwg-displays # GUI output management
      shikane # automatic output management
    ];
    # services.kanshi = {
    #   enable = false; # so that the config file can be written to by wlay
    #   systemdTarget = wayland.systemd.target;
    # };
    # systemd.user.services."kanshi" = lib.mkIf (!kanshi.enable) {
    #   Unit = {
    #     Description = "Dynamic output configuration";
    #     Documentation = "man:kanshi(1)";
    #     PartOf = [kanshi.systemdTarget];
    #     Requires = [kanshi.systemdTarget];
    #     After = [kanshi.systemdTarget];
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${kanshi.package}/bin/kanshi";
    #     Restart = "always";
    #   };
    #   Install = {
    #     WantedBy = [kanshi.systemdTarget];
    #   };
    # };

    systemd.user.services."shikane" = {
      Unit = {
        Description = "Dynamic output configuration";
        Documentation = "man:shikane(1)";
        PartOf = [wayland.systemd.target];
        Requires = [wayland.systemd.target];
        After = [wayland.systemd.target];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.shikane}/bin/shikane";
        Restart = "always";
      };
      Install = {
        WantedBy = [wayland.systemd.target];
      };
    };
  };
  meta = {};
}

