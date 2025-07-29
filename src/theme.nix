{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
in
{
  options.desktop.theme = with lib; {
    inputs = mkOption {
      type = types.attrsOf types.anything;
      default = { };
    };
  };
  imports = lib.listFilePaths ./theme;
  config = {
    home.packages = with pkgs; [
      glib.bin
    ];

    stylix = {
      icons = {
        enable = true;
        package = pkgs.kdePackages.breeze-icons;
        light = "breeze-dark";
        dark = "breeze-dark";
      };
      targets.neovim.enable = false;
    };

    gtk = {
      enable = true;
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };
      gtk3 = {
        bookmarks = map (dir: "file://${dir}") (std.attrValues config.xdg.userDirs.extraConfig);
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
