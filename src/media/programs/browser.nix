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
  imports = [];
  config = {
    home.packages = with pkgs; [
      vivaldi
      vivaldi-ffmpeg-codecs
      widevine-cdm
    ];
  };
}
