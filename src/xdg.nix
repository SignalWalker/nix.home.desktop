{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {
  };
  disabledModules = [];
  imports = [];
  config = {
    xdg = {
      mime.enable = true;
      portal = {
        enable = false;
      };
      autostart = {
        enable = true;
        readOnly = true;
      };
    };
  };
  meta = {};
}
