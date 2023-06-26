{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
  wp = cfg.wallpaper;
in {
  options.signal.desktop.wayland.wallpaper = with lib; {
    enable = (mkEnableOption "wallpaper") // {default = true;};
    randomizeCmd = mkOption {
      type = types.str;
      default = "echo";
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./wallpaper;
  config = lib.mkIf (cfg.enable && wp.enable) {
    services.swww = {
      enable = true;
      # package = lib.signal.home.linkSystemApp pkgs {app = "swww";};
      systemd.enable = true;
      img.path = config.xdg.userDirs.extraConfig."XDG_WALLPAPERS_DIR";
    };
    signal.desktop.wayland.wallpaper.randomizeCmd = "swww-randomize --animated ${config.services.swww.img.path}";
    services.wpaperd = {
      enable = !config.services.swww.enable;
      systemd = {
        enable = true;
        target = cfg.systemd.target;
      };
      package = lib.signal.home.linkSystemApp pkgs {app = "wpaperd";};
      settings = {
        default = {
          path = config.xdg.userDirs.extraConfig."XDG_WALLPAPERS_DIR";
          duration = "30m";
          apply-shadow = false;
        };
      };
    };
  };
}
