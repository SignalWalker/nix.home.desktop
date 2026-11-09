{
  config,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./wallpaper;
  config = {
    services.awww = {
      enable = true;
      systemd.enable = true;
      img.path = config.xdg.userDirs.extraConfig."WALLPAPERS";
    };
    desktop.keybinds = {
      wallpaperRandomize = {
        modifiers = [
          "SUPER"
          "ALT"
        ];
        keysym = "W";
        description = "randomize wallpaper";
        umbriel = {
          enable = true;
          action = lib.mkDefault "spawn";
          args = lib.mkDefault [ "wallmaster randomize" ];
        };
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "exec_raw";
          args = lib.mkDefault [ "wallmaster randomize" ];
        };
      };
    };
    # services.wpaperd = {
    #   enable = !config.services.awww.enable;
    #   systemd = {
    #     enable = true;
    #     target = cfg.systemd.target;
    #   };
    #   settings = {
    #     default = {
    #       path = config.xdg.userDirs.extraConfig."WALLPAPERS";
    #       duration = "30m";
    #       apply-shadow = false;
    #     };
    #   };
    # };
  };
}
