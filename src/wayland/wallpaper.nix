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
          "MOD3"
          "ALT"
        ];
        keysym = "W";
        description = "randomize wallpaper";
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "execr";
          args = lib.mkDefault [ "systemctl --user start awww-randomize.service" ];
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
