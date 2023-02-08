{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
  mnu = cfg.menu;
  rofi = config.programs.rofi;
  wofi = config.programs.wofi;
  yofi = config.programs.yofi;
in {
  options.signal.desktop.wayland.menu = with lib; {
    enable = (mkEnableOption "launcher menu config") // {default = true;};
    cmd = mkOption {
      type = types.str;
      default = "${wofi.package}/bin/wofi --show=drun,run";
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./menu;
  config = lib.mkIf (cfg.enable && mnu.enable) {
    signal.desktop.shared.rofi.enable = false;
    programs.rofi.package = lib.mkForce pkgs.rofi-wayland;
    programs.yofi = {
      enable = false;
    };
    programs.wofi = {
      enable = !(rofi.enable || yofi.enable);
      settings = {
        layer = "overlay";
        width = "50%";
        height = "40%";
        dynamic_lines = true;
        normal_window = false;
        allow_images = true;
        allow_markup = true;
        matching = "fuzzy";
        insensitive = true;
        term = config.signal.desktop.terminal.command;
      };
    };
  };
}
