{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.desktop.theme = {
    inputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
  };
  imports = lib.listFilePaths ./theme;
  config =
    let
      inputs = config.desktop.theme.inputs;
      stylix = config.stylix;
    in
    {
      home.packages = [
        # TODO :: why
        pkgs.glib.bin
      ];

      stylix = {
        icons = {
          enable = true;
          package = pkgs.rose-pine-icon-theme;
          light = "oomox-RoséPine-Dawn_";
          dark = "oomox-RoséPine-Moon";
        };
        targets.neovim.enable = false;
      };

      xdg.configFile."hypr/hyprqt6engine.conf" = {
        text = lib.hm.generators.toHyprconf {
          attrs = {
            theme = {
              color_scheme = "${inputs.rose-pine-qt5ct}/rose-pine.conf";
              icon_theme = stylix.icons.dark;
            };
            misc = {

            };
          };
        };
      };

      gtk = {
        enable = true;
        gtk2 = {
          configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        };
        gtk3 = {
          bookmarks = map (dir: "file://${dir}") (lib.attrValues config.xdg.userDirs.extraConfig);
        };
        gtk4 = { };
      };
      dconf.settings = {
        # "org/gtk/settings/file-chooser" = {
        #   "sort-directories-first" = true;
        # };
      };
      qt = {
        enable = true;
      };
      systemd.user.sessionVariables = {
        "_JAVA_OPTIONS" = "-Dawt.useSystemAAFontSettings=lcd";
      };
    };
}
