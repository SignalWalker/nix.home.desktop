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
    signal.desktop.wayland.compositor.scratchpads = [
      {
        kb = "Shift+A";
        criteria = {class = "Authy Desktop";};
        startup = "authy";
      }
      {
        kb = "Shift+P";
        criteria = {class = "Bitwarden";};
        resize = 75;
        startup = "bitwarden-desktop";
      }
    ];
  };
}
