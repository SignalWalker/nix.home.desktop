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
    home.packages = with pkgs; [
      dolphin-emu-beta
      duckstation
      # pcsx2 # disabled for build error
      ppsspp
      mgba
      # snes9x-gtk
      melonDS
      (retroarch.override {
        cores = with libretro; [
          beetle-saturn
          flycast
          # fbneo
          # parallel-n64 # build error
          mupen64plus
        ];
      })
      xdelta
      # xivlauncher
      lutris
      cockatrice
      xorg.xauth # for docker-mtgo
      moonlight-qt
      prismlauncher
    ];
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;
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
