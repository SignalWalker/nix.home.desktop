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
      # fails to build as of 2023-08-07
      # jellyfin-mpv-shim
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
          obs-vkcapture
        ];
      })
      aseprite-unfree
      gimp
      krita
      blender
    ];
  };
  meta = {};
}
