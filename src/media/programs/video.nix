{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    home.packages = with pkgs; [
      jellyfin-media-player
      jellyfin-mpv-shim
    ];
  };
  meta = {};
}
