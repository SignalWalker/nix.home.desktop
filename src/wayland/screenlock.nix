{
  pkgs,
  lib,
  ...
}:
{
  config = {
    desktop.keybinds = {
      sessionLock = {
        modifiers = [
          "MOD3"
          "ALT"
        ];
        keysym = "L";
        description = "lock session";
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "execr";
          args = lib.mkDefault [ "swaylock --effect-scale 0.5 --effect-blur 5x3" ];
        };
      };
    };
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = true;
        indicator-caps-lock = true;
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
