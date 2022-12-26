{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wln = config.signal.desktop.wayland;
  lck = wln.screenlock;
  theme = config.signal.desktop.theme;
  fontCfg = theme.font;
in {
  options.signal.desktop.wayland.screenlock = with lib; {
    enable = (mkEnableOption "screenlock") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (wln.enable && lck.enable) {
    programs.swaylock.settings = let
      font = head fontCfg.slab;
    in {
      ignore-empty-password = true;
      indicator-caps-lock = true;
      font = font.name;
      font-size = font.selectSize 11;
      image = "${config.xdg.userDirs.extraConfig."XDG_WALLPAPERS_DIR"}/pond_bg.png";
      scaling = "fit";
      color = "000000";
    };
  };
}
