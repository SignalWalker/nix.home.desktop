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
        restore = "${dusntctl} history-pop";
        dismiss = "${dunstctl} close";
        context = "${dunstctl} context";
      };
    };
    services.dunst = {
      settings = {
        global = {
          follow = "keyboard";
          enable_posix_regex = true;

          width = "(0, ${2256 / 6})";
          height = "(0, ${1504 / 8})";

          origin = "bottom-right";
          offset = "(8, 8)";

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
        };
      };
    };
  };
  meta = {};
}
