{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.desktop.wayland.compositor;
in {
  options = with lib; {};
  imports = lib.listFilePaths ./compositor;
  config = {
  };
}