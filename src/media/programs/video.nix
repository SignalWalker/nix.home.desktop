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
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
          obs-vkcapture
        ];
      })
      aseprite-unfree
      gimp
    ];
  };
  meta = {};
}
