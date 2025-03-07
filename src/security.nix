{
  config,
  osConfig,
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
  config = lib.mkMerge [
    (lib.mkIf (osConfig.programs.gnupg.agent.enable or false) {
      home.packages = with pkgs; [
        # gnupg GUI interface
        seahorse
      ];
    })
    {
      systemd.user.services."polkit-kde-authentication-agent-1" = {
        Unit = {
          Description = "polkit-kde-authentication-agent-1";
          PartOf = ["graphical-session.target"];
          Before = ["graphical-session.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 12;
        };
        Install = {
          WantedBy = ["graphical-session-pre.target"];
        };
      };
    }
  ];
  meta = {};
}
