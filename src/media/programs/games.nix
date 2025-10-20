{
  pkgs,
  ...
}:
{
  options = { };
  imports = [ ];
  config = {
    home.packages = [
      # launchers
      # pkgs.lutris
      # pkgs.heroic

      # pkgs.ruffle # flash

      # pkgs.parsec-bin
      # pkgs.moonlight-qt
    ];

    # manage these with `nix profile` instead

    # (pkgs.retroarch.withCores (
    #   cores: with cores; [
    #     # this is only because i want retroachievements for some systems whose real emulators don't support it (or don't support it well; i.e. bizhawk not allowing hardcore, seemingly)
    #     # nintendo
    #     nestopia # TODO :: is this really the best one...?
    #     snes9x
    #     mupen64plus
    #     # NEC
    #     beetle-pce-fast
    #     beetle-pcfx
    #     beetle-supergrafx
    #     # sega
    #     beetle-saturn
    #   ]
    # ))
    # ## sony
    # pkgs.pcsx2 # ps2
    # pkgs.ppsspp # psp
    # ## nintendo
    # pkgs.mgba # gb/gbc/gba (no retroachievements)
    # pkgs.skyemu # gb/gbc/gba/ds (retroachievements)
    # pkgs.snes9x-gtk # snes
    # pkgs.dolphin-emu-beta # gcn/wii
    # pkgs.azahar # 3ds
    # ## sega
    # pkgs.yabause # saturn
    # pkgs.flycast # dreamcast
    # # games
    # pkgs.space-station-14-launcher
    # pkgs.xivlauncher
    # pkgs.srb2
    # pkgs.ringracers
    # pkgs.prismlauncher
    # pkgs.openrct2
    # pkgs.openttd
    # pkgs.cockatrice
    # pkgs.forge-mtg

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
      # TODO :: what is this
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
