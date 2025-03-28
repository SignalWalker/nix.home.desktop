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
  options = with lib; {
  };
  imports = lib.signal.fs.path.listFilePaths ./compositor;
  config = {
  };
}

