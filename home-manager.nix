{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.desktop.polybarScripts = with lib;
    mkOption {
      type = types.attrsOf types.anything;
    };
  imports = lib.listFilePaths ./src;
  config = {
    home.stateVersion = "22.11";
  };
}