{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  cfg = config.signal.media.im.irc;
in
{
  options.signal.media.im.irc = with lib; {
    enable = (mkEnableOption "IRC") // {
      default = true;
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf cfg.enable {
    programs.halloy = {
      enable = true;
      settings = {
        buffer = {
          chathistory = {
            infinite_scroll = true;
          };
        };
        keyboard = {
          move_up = "alt+k";
          move_down = "alt+j";
          move_left = "alt+h";
          move_right = "alt+l";
        };
        servers =
          let
            cfgDir = "${config.xdg.configHome}/halloy";
            keyDir = "${cfgDir}/keys";
            bouncer = "bouncer.irc.terra.ashwalker.net";
            bPort = 6667;
            bPassFile = "${keyDir}/bouncer.key";
          in
          {
            "soju" = {
              nickname = "ash";
              server = bouncer;
              port = bPort;
              dangerously_accept_invalid_certs = true;
              sasl = {
                plain = {
                  username = "ash";
                  password_file = bPassFile;
                };
              };
            };
          };
      };
    };
    desktop.scratchpads = {
      "Shift+I" = {
        criteria = {
          app_id = "org.squidowl.halloy";
        };
        resize = 83;
        startup = "halloy";
        systemdCat = true;
        autostart = true;
        automove = true;
      };
    };

    # xdg.dataFile."weechat/python/autoload/notify_send.py".source =
    #   "${pkgs.weechatScripts.weechat-notify-send}/share/notify_send.py";
  };
  meta = { };
}

