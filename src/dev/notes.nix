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
    home.packages = [
      pkgs.obsidian
    ];
    signal.desktop.scratch.scratchpads = {
      "Shift+N" = {
        criteria = {app_id = "scratch_notes";};
        resize = 83;
        startup = "kitty --class scratch_notes nvim $XDG_NOTES_DIR";
        automove = true;
        autostart = true;
      };
      "Shift+O" = {
        criteria = {
          class = "obsidian";
          instance = "obsidian";
        };
        resize = 83;
        startup = "obsidian";
        automove = true;
        autostart = true;
      };
    };
  };
  meta = {};
}
