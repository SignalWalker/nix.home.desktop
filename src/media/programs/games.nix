{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  inputs = config.signal.media.flakeInputs;
in
{
  options = with lib; { };
  imports = [ ];
  config = {
    home.packages =
      (
        if hasAttr pkgs.system inputs.bizhawk.packages then
          [
            inputs.bizhawk.packages.${pkgs.system}.emuhawk-latest-bin
          ]
        else
          [ ]
      )
      ++ (with pkgs; [
        # launchers
        lutris
        heroic
        # emulationstation-de # FIX :: disabled due to freeimage cve
        # emulators
        ## multi
        (retroarch.withCores (
          cores: with cores; [
            # this is only because i want retroachievements for some systems whose real emulators don't support it (or don't support it well; i.e. bizhawk not allowing hardcore, seemingly)
            # nintendo
            nestopia # TODO :: is this really the best one...?
            snes9x
            mupen64plus
            # NEC
            beetle-pce-fast
            beetle-pcfx
            beetle-supergrafx
            # sega
            beetle-saturn
          ]
        ))
        ## misc
        ruffle # flash
        ## sony
        duckstation # psx
        pcsx2 # ps2
        ppsspp # psp
        ## nintendo
        mgba # gb/gbc/gba (no retroachievements)
        skyemu # gb/gbc/gba/ds (retroachievements)
        snes9x-gtk # snes
        dolphin-emu-beta # gcn/wii
        azahar # 3ds
        ## sega
        yabause # saturn
        flycast # dreamcast
        # tools
        parsec-bin
        moonlight-qt
        # games
        space-station-14-launcher
        # openmw # NOTE :: using openmw-dev; installed through desktop flake
        # openmw-tes3mp
        # portmod # openmw mod manager (?)
        xivlauncher
        srb2
        prismlauncher
        openrct2
        openttd
        cockatrice
        forge-mtg
      ]);

    desktop.windows = [
      {
        criteria = {
          title = "Steam - Update News";
          class = "steam";
        };
        floating = true;
      }
      {
        criteria = {
          title = "Steam Settings";
          class = "steam";
        };
        floating = true;
      }
      {
        criteria = {
          instance = "tk";
          class = "Tk";
        };
        floating = true;
      }
    ];

    programs.mangohud = {
      enable = true;
      enableSessionWide = false;
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
