{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
with builtins; {
  imports = lib.signal.fs.listFiles ./audio;
}
