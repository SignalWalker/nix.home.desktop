{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  dunst = config.services.dunst;
  theme = config.desktop.theme;
in {
  options = with lib; {
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf dunst.enable {
    desktop.notifications = {
      commands = let
        dunstctl = "${dunst.package}/bin/dunstctl";
      in {
        restore = "${dunstctl} history-pop";
        dismiss = "${dunstctl} close";
        context = "${dunstctl} context";
      };
    };
    services.dunst = {
      settings = let
        colors = theme.colors.signal;
      in {
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

          font = let
            size = 11;
            fonts = theme.font.slab ++ theme.font.symbols;
          in
            std.concatStringsSep ", " (map (font: "${font.name} ${toString (font.selectSize size)}") fonts);

          icon_theme = config.gtk.iconTheme.name;
          enable_recursive_icon_lookup = true;

          dmenu = "${pkgs.bemenu}/bin/bemenu -p dunst";

          background = "#${colors.bg}aa";
          foreground = "#${colors.fg}";
          highlight = "#${colors.fg}"; # progress bar
          frame_color = "#${colors.border}";
        };
        urgency_low = {
          background = "#${colors.bg-low-priority}aa";
          foreground = "#${colors.fg-low-priority}";
          highlight = "#${colors.fg-low-priority}"; # progress bar
        };
        urgency_normal = {
          background = "#${colors.bg-normal-priority}aa";
          foreground = "#${colors.fg-normal-priority}";
          highlight = "#${colors.fg-normal-priority}"; # progress bar
        };
        urgency_critical = {
          background = "#${colors.bg-critical}aa";
          foreground = "#${colors.fg-critical}";
          highlight = "#${colors.fg-critical}"; # progress bar
          timeout = "1d";
        };
      };
    };
  };
  meta = {};
}
