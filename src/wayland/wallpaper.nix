{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
in {
  options.signal.desktop.wayland.wallpaper = with lib; {
    enable = (mkEnableOption "wallpaper") // {default = true;};
    default-bg = mkOption {
      type = types.nullOr (types.either types.str types.path);
      default = null;
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.wallpaper.enable && cfg.wallpaper.default-bg != null) {
    home.packages = with pkgs; [
      swaybg
    ];
    # xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper/hyprpaper.conf;
    signal.desktop.wayland.startupCommands = "swaybg -c '#000000' -m center -i ${cfg.wallpaper.default-bg} &";
  };
}
