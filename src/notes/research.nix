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
    signal.desktop.scratch.scratchpads = {
      "Shift+Z" = {
        criteria = {class = "Zotero";};
        resize = 93;
        startup = "zotero";
      };
    };
  };
  meta = {};
}
