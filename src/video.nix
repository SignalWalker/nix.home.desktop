{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
in
{
  options = with lib; { };
  disabledModules = [ ];
  imports = [ ];
  config = {
    programs.mpv = {
      enable = true;
    };
    programs.imv = {
      enable = true;
      settings = {
        options = {
          upscaling_method = "nearest_neighbour";
          overlay = true;
        };
      };
    };
  };
  meta = { };
}
