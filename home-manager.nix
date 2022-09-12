{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.desktop = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./src;
  config = {
    home.stateVersion = "22.11";
  };
}
