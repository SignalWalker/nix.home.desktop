{ config
, pkgs
, lib
, ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
  mnu = cfg.menu;
in
{
  options.signal.desktop.wayland.menu = with lib; {
    enable = (mkEnableOption "launcher menu config") // { default = true; };
    cmd = mkOption {
      type = types.str;
      default = "${config.programs.wofi.package}/bin/wofi --show drun";
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./menu;
  config = lib.mkIf (cfg.enable && mnu.enable) {
    signal.desktop.shared.rofi.enable = false;
    programs.rofi.package = lib.mkForce pkgs.rofi-wayland;
    programs.wofi = {
      enable = !config.signal.desktop.shared.rofi.enable;
      settings = {
        layer = "top";
        width = "50%";
        height = "40%";
        dynamic_lines = true;
        normal_window = false;
        allow_images = true;
        insensitive = true;
        term = config.signal.desktop.terminal.command;
      };
    };
  };
}
