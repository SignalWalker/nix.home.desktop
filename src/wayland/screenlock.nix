{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  wln = config.desktop.wayland;
  lck = wln.screenlock;
  theme = config.desktop.theme;
in
{
  options.desktop.wayland.screenlock = with lib; {
    enable = (mkEnableOption "screenlock") // {
      default = true;
    };
  };
  imports = [ ];
  config = lib.mkIf lck.enable {
    programs.swaylock = {
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
