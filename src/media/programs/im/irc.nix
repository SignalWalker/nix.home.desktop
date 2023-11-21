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
    # programs.hexchat = {
    #   enable = true;
    # };
    home.packages = [pkgs.weechat];
    signal.desktop.scratch.scratchpads = {
      "Shift+I" = {
        criteria = {app_id = "weechat";};
        resize = 83;
        startup = "kitty --class weechat weechat";
        autostart = true;
        automove = true;
      };
    };

    xdg.dataFile."weechat/python/autoload/notify_send.py".source = "${pkgs.weechatScripts.weechat-notify-send}/share/notify_send.py";
  };
  meta = {};
}
