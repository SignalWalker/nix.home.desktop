{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; {
  imports = lib.signal.fs.path.listFilePaths ./audio;
}
