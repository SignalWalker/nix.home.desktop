{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  anki = config.programs.anki;
in
{
  options = with lib; {
  };
  disabledModules = [ ];
  imports = [ ];
  config = {
    programs.anki = {
      enable = true;
    };
    desktop.windows = [
      {
        criteria = {
          instance = "anki";
          class = "Anki";
          title = "(Preferences)|(Add)";
        };
        floating = true;
      }
    ];
    desktop.scratchpads = {
      "Shift+A" = {
        criteria = {
          instance = "anki";
          class = "Anki";
          title = ".* - Anki";
        };
        hypr = {
          process_tracking = false;
        };
        resize = 83;
        startup = "anki";
        systemdCat = true;
        autostart = true;
        automove = true;
      };
    };
  };
  meta = { };
}
