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
    desktop.notifications = {
      commands = {
        restore = mkOption {
          type = types.str;
        };
        dismiss = mkOption {
          type = types.str;
        };
        context = mkOption {
          type = types.str;
        };
      };
    };
  };
  disabledModules = [];
  imports = lib.listFilePaths ./notifications;
  config = {
  };
  meta = {};
}