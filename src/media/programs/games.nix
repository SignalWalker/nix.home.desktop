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
      anki
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
      space-station-14-launcher
    ];
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        fps_limit = 60;
        fps_limit_method = "early";
        vsync = 0;

        # # disable linear texture filtering
        # retro = true;

        time = true;
        time_no_label = true;
        time_format = "%H:%M";

        ram = true;
        vram = true;

        gpu_name = true;
        vulkan_driver = true;

        wine = true;
        winesync = true;

        gamemode = true;

        position = "bottom-right";
        font_size = 12;
        font_size_text = 12; # ???
        hud_compact = true;
        hud_no_margin = true;

        toggle_hud = "Shift_R+F12";
        toggle_hud_position = "Shift_R+F11";
      };
      settingsPerApplication = {
      };
    };
  };
}
