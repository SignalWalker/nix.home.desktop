{
  config,
  pkgs,
  lib,
  ...
}:
let
  anki = config.programs.anki;
in
{
  config = {
    programs.anki = {
      enable = true;
    };
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
