{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.x11;
  mcfg = config.signal.desktop.x11.menu;
in {
  options.signal.desktop.x11.menu = with lib; {
    enable = (mkEnableOption "system menu") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && mcfg.enable) {
    signal.desktop.shared.rofi.enable = true;
  };
}
