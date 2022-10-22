{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
  lck = cfg.screenlock;
in {
  options.signal.desktop.wayland.screenlock = with lib; {
    enable = (mkEnableOption "screenlock") // {default = true;};
    font = mkOption {
      type = config.lib.signal.types.font;
      default = head config.signal.desktop.theme.font.slab;
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable && lck.enable) {
    programs.swaylock.settings = {
      ignore-empty-password = true;
      indicator-caps-lock = true;
      font = lck.font.family;
      font-size = config.lib.signal.desktop.theme.font.selectSize {
        font = lck.font;
        ideal = 11;
      };
      image = "${config.xdg.userDirs.extraConfig."XDG_WALLPAPERS_DIR"}/pond_bg.png";
      scaling = "fit";
      color = "000000";
    };
  };
}
