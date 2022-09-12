{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland.compositor;
in {
  options.signal.desktop.wayland.compositor = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./compositor;
  config = {};
}
