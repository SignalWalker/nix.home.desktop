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
        startup = "kitty --class scratch_notes nvim +\"tcd ${config.xdg.userDirs.extraConfig.XDG_NOTES_DIR}\" +ObsidianYesterday +vsp +ObsidianToday";
        systemdCat = true;
        automove = true;
        autostart = false;
      };
      "Shift+O" = {
        criteria = {
          app_id = "obsidian";
        };
        resize = 83;
        startup = "obsidian";
        systemdCat = true;
        automove = true;
        autostart = false;
      };
    };
  };
  meta = {};
}
