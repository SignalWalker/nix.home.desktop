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
  };
  imports = lib.signal.fs.path.listFilePaths ./wallpaper;
  config = lib.mkIf (cfg.enable && wp.enable) {
    services.swww = {
      enable = false;
      package = lib.signal.home.linkSystemApp pkgs { app = "swww"; };
    };
    services.wpaperd = {
      enable = !config.services.swww.enable;
      systemd.enable = true;
      package = lib.signal.home.linkSystemApp pkgs { app = "wpaperd"; };
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
