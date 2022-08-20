inputs @ {
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.signal.desktop.x11.enable) {
    xresources = {
      path = "${config.xdg.configHome}/xresources";
      properties = {};
    };
  };
}
