{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  wayland = config.desktop.wayland;
  kanshi = config.services.kanshi;
in
{
  options = with lib; {
  };
  disabledModules = [ ];
  imports = [ ];
  config = {
    home.packages = with pkgs; [
      nwg-displays # GUI output management
    ];
    services.shikane = {
      enable = true;
      settings = {
        profile = [
          {
            name = "builtin-only";
            output = [
              {
                match = "eDP-1";
                enable = true;
              }
            ];
          }
        ];
      };
    };
  };
  meta = { };
}
