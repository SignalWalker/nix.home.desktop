{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  dunst = config.services.dunst;
  theme = config.desktop.theme;
in
{
  config = lib.mkIf dunst.enable {
    desktop.keybinds =
      let
        dunstctl = "${dunst.package}/bin/dunstctl";
      in
      {
        notificationsRestore = {
          hypr = {
            enable = true;
            dispatcher = "execr";
            args = [ "${dunstctl} history-pop" ];
          };
        };
        notificationsDismiss = {
          hypr = {
            enable = true;
            dispatcher = "execr";
            args = [ "${dunstctl} close" ];
          };
        };
        notificationsOpenMenu = {
          hypr = {
            enable = true;
            dispatcher = "execr";
            args = [ "${dunstctl} context" ];
          };
        };
      };
    services.dunst = {
      settings =
        let
          colors = theme.colors.signal;
        in
        {
          global = {
            follow = "keyboard";
            enable_posix_regex = true;

            markup = "full";

            width = "(0, ${toString (floor (2256 / 6))})";
            height = "(0, ${toString (floor (1504 / 8))})";

            origin = "bottom-right";
            offset = "(12, 12)";

            frame_width = 1;
            gap_size = 2;

            idle_threshold = "12m";

            enable_recursive_icon_lookup = true;

            dmenu = "${pkgs.fuzzel}/bin/fuzzel --dmenu -p dunst ";

            format = "<i>%a</i>\\n<b>%s</b>\\n%b";

          };
          audio = {
            appname = "Tauon Music Box";
            origin = "bottom-left";
          };
          urgency_low = {
            origin = "bottom-left";
          };
          urgency_critical = {
            timeout = "1d";
            origin = "top-right";
          };
        };
    };
  };
  meta = { };
}
