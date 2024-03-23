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
        startup = "kitty --class scratch_notes nvim \"+ObsidianToday -1\" +vsp +ObsidianToday";
        systemdCat = true;
        automove = true;
        autostart = true;
      };
      "Shift+O" = {
        criteria = {
          app_id = "obsidian";
        };
        resize = 83;
        startup = "obsidian";
        systemdCat = true;
        automove = true;
        autostart = true;
      };
    };
  };
  meta = {};
}
