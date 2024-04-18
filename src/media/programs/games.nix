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
  imports = [];
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
      heroic
      itch
    ];
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;
      settings = {
      };
      settingsPerApplication = {
      };
    };
  };
}
