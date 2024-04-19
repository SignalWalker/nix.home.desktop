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
  disabledModules = [];
  imports = [];
  config = {
    home.packages = with pkgs; [
      bitwarden
      # authy
    ];

    signal.desktop.scratch.scratchpads = {
      # "Shift+A" = {
      #   criteria = {class = "Authy Desktop";};
      #   startup = "authy";
      #   autostart = false;
      #   automove = false;
      # };
      "Shift+P" = {
        criteria = {app_id = "Bitwarden";};
        resize = 75;
        startup = "bitwarden";
        systemdCat = true;
        autostart = false;
        automove = true;
      };
    };
  };
  meta = {};
}
