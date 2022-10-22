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
    systemd = {
      enable = (mkEnableOption "systemd integration") // {default = false;};
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      signal.desktop.wayland.compositor.scratchpads = [
        {
          kb = "Shift+I";
          criteria = {app_id = "scratch_irc";};
          resize = 83;
          startup = "kitty --class scratch_irc weechat";
        }
      ];
    }
    (lib.mkIf cfg.systemd.enable {
      systemd.user.services."irc-relay" = {
        Unit = {
          Description = "IRC relay server";
          After = ["network.target"];
        };
        Install = {
          WantedBy = ["default.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "weechat-headless";
        };
      };
    })
  ]);
  meta = {};
}
