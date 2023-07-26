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
  imports = lib.signal.fs.path.listFilePaths ./games;
  config = {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
      };
      settingsPerApplication = {
      };
    };
    # home.packages = with pkgs; [
    #   moonlight-qt
    # ];
    # systemd.user.services."sunshine" = {
    #   Unit = {
    #     Description = "self-hosted game stream host for Moonlight";
    #     After = ["network-online.target"];
    #     Wants = ["network-online.target"];
    #     StartLimitIntervalSec = 500;
    #     StartLimitBurst = 5;
    #   };
    #   Service = {
    #     ExecStart = "${pkgs.sunshine}/bin/sunshine";
    #     Restart = "on-failure";
    #     RestartSec = "5s";
    #   };
    #   Install = {
    #     WantedBy = ["graphical-session.target"];
    #   };
    # };
  };
}
