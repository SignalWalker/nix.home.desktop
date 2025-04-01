{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  anki = config.programs.anki;
in {
  options = with lib; {
    programs.anki = {
      enable = (mkEnableOption "anki") // {default = true;};
      package = mkPackageOption pkgs "anki-bin" {};
    };
  };
  disabledModules = [];
  imports = [];
  config = {
    home.packages = [
      anki.package
    ];
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
  meta = {};
}
