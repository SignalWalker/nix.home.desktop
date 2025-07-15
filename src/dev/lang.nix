{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev;
in {
  options = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./lang;
  config = {};
}
