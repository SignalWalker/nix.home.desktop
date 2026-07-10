{
  pkgs,
  ...
}:
{
  options = { };
  imports = [ ];
  config = {
    systemd.user.sessionVariables = {
      PROTON_ENABLE_WAYLAND = 1;
    };

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
