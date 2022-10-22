{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.media.im = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./im;
  config = {};
}
