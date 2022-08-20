{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.desktop.x11.notifications = with lib; {
    backend = mkOption {
      type = types.enum [ "dunst" "wired" ];
      default = "dunst";
    };
  };
  imports = lib.signal.fs.listFiles ./notifications;
  config = {};
}
