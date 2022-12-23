{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./programs;
  config = {
    services.kdeconnect.enable = true;
    signal.desktop.scratch.scratchpads = {
      "Shift+A" = {
        criteria = {class = "Authy Desktop";};
        startup = "authy";
        autostart = true;
        automove = true;
      };
      "Shift+P" = {
        criteria = {class = "Bitwarden";};
        resize = 75;
        startup = "bitwarden-desktop";
        autostart = true;
        automove = true;
      };
    };
  };
}
