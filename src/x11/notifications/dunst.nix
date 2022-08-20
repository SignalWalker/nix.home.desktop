{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.x11;
  ncfg = cfg.notifications;
  dcfg = ncfg.dunst;
in {
  options.signal.desktop.x11.notifications.dunst = with lib; {
    package = mkOption {
      type = types.package;
      default = pkgs.dunst;
    };
    font = mkOption {
      type = config.lib.signal.types.fontInst;
      default = {
        font = head (config.lib.signal.desktop.theme.bmpsAt 13);
        size = 13;
      };
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable && (ncfg.backend == "dunst")) {
    home.packages = [dcfg.font.font.package];
    services.dunst = {
      enable = true;
      configFile = "${config.xdg.configHome}/dunst/dunstrc";
      settings = {
        global = {
          monitor = 0;
          follow = "keyboard";
          width = "(0,400)";
          height = "(0,400)";
          origin = "top-right";
          offset = "8x30";
          scale = 0;
          notification_limit = 0;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          indicate_hidden = true;
          transparency = 10;
          separator_height = 1;
          padding = 2;
          horizontal_padding = 2;
          text_icon_padding = 0;
          frame_width = 1;
          frame_color = "#aaaaaa";
          separator_color = "frame";
          sort = true;
          font = "${dcfg.font.font.family} ${toString dcfg.font.size}";
          line_height = 0;
          markup = "full";
          format = "%a\\n<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;
          sticky_history = false;
          history_length = 48;
          dmenu = "dmenu -p dunst";
          browser = "xdg-open";
          always_run_script = true;
          title = "dunst";
          class = "dunst";
          corner_radius = 0;
          ignore_dbusclose = false;
          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "close_current";
          mouse_right_click = "close_all";
        };
        experimental = {
          per_monitor_dpi = false;
        };

        urgency_low = {
          background = "#222222";
          foreground = "#888888";
          timeout = 12;
        };

        urgency_normal = {
          background = "#285577";
          foreground = "#ffffff";
          timeout = 12;
        };

        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 0;
        };
        fullscreen_delay_everything.fullscreen = "pushback";
        fullscreen_show_critical = {
          msg_urgency = "critical";
          fullscreen = "show";
        };
      };
    };
  };
}
