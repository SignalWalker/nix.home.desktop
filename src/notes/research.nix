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
    home.packages = with pkgs; [zotero];
    desktop.scratchpads = {
      "Shift+Z" = {
        criteria = {
          # class = "Zotero";
          # instance = "Navigator";
          app_id = "Zotero";
          title = ".*- Zotero";
        };
        resize = 93;
        name = "zotero";
        startup = "zotero";
        autostart = false;
        automove = true;
      };
    };
  };
  meta = {};
}
