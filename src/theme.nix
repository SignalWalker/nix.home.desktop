{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.desktop.theme = with lib; {
    inputs = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./theme;
  config = {
    gtk = {
      enable = true;
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };
      gtk3 = {
        bookmarks = map (dir: "file://${dir}") (std.attrValues config.xdg.userDirs.extraConfig);
      };
      gtk4 = {};
      theme = {
        package = pkgs.kdePackages.breeze;
        name = "breeze";
      };
      iconTheme = {
        package = pkgs.kdePackages.breeze-icons;
        name = "breeze";
      };
    };
    qt = {
      enable = true;
      platformTheme = {
        name = "gtk3";
      };
      style = {
        name = "breeze";
        # package = pkgs.kdePackages.breeze;
      };
    };
    home.pointerCursor = {
      package = pkgs.rose-pine-cursor;
      # NOTE :: this is the name of the folder within `{pkg}/share/icons/`
      name = "BreezeX-RosePineDawn-Linux";
      gtk.enable = true;
      x11.enable = true;
      size = 24;
    };
  };
}
