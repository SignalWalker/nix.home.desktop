{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.media.im.irc;
in {
  options.signal.media.im.irc = with lib; {
    enable = (mkEnableOption "IRC") // {default = true;};
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.hexchat = {
      enable = true;
    };
    signal.desktop.scratch.scratchpads = {
      "Shift+I" = {
        criteria = {app_id = "hexchat";};
        resize = 83;
        startup = "hexchat";
        autostart = true;
        automove = true;
      };
    };
  };
  meta = {};
}
