{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wayland = config.desktop.wayland;
  kanshi = config.services.kanshi;
in {
  options = with lib; {
  };
  disabledModules = [];
  imports = lib.signal.fs.path.listFilePaths ./display;
  config = {
    home.packages = with pkgs; [
      nwg-displays # GUI output management
    ];
  };
  meta = {};
}
