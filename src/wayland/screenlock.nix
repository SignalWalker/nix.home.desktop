{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wln = config.desktop.wayland;
  lck = wln.screenlock;
  theme = config.desktop.theme;
  fontCfg = theme.font;
in {
  options.desktop.wayland.screenlock = with lib; {
    enable = (mkEnableOption "screenlock") // {default = true;};
  };
  imports = [];
  config = lib.mkIf lck.enable {
    programs.swaylock = {
      package = pkgs.swaylock-effects;
      settings = let
        font = head fontCfg.slab;
      in {
        ignore-empty-password = true;
        indicator-caps-lock = true;
        font = font.name;
        font-size = font.selectSize 11;
        # image = "${config.xdg.userDirs.extraConfig."XDG_WALLPAPERS_DIR"}/pond_bg.png";
        scaling = "fit";
        color = "000000";
        clock = true;
        indicator = true;
        screenshots = true;
        datestr = "%a, %Y-%M-%d";
      };
    };
  };
}

