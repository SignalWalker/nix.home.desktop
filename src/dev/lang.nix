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
  imports = lib.listFilePaths ./lang;
  config = {};
}