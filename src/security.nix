{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    systemd.user.services."polkit-kde-authentication-agent-1" = {
      Unit = {
        Description = "polkit-kde-authentication-agent-1";
        PartOf = ["graphical-session.target"];
        Before = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 12;
      };
      Install = {
        WantedBy = ["graphical-session-pre.target"];
      };
    };
  };
  meta = {};
}
