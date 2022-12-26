{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.desktop.theme = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./theme;
  config = {
    gtk = {
      enable = true;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3 = {
        bookmarks = map (dir: "file:///${dir}") (std.attrValues config.xdg.userDirs.extraConfig);
      };
      iconTheme = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adwaita";
      };
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita";
      };
    };
    qt = {
      platformTheme = "gnome";
      style = {
        package = pkgs.adwaita-qt;
        name = "adwaita";
      };
    };
    home.pointerCursor = {
      # package = pkgs.nordzy-cursor-theme;
      # package = pkgs.quintom-cursor-theme;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      gtk.enable = true;
      size = 24;
    };
  };
}
