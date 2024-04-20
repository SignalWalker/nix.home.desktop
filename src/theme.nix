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
    home.packages = with pkgs; [
      glib.bin
    ];
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
        package = pkgs.breeze-gtk;
        name = "Breeze";
      };
      iconTheme = {
        package = pkgs.kdePackages.breeze-icons;
        # NOTE :: experimentally, this has to be lowercase???
        name = "breeze";
      };
    };
    qt = {
      enable = true;
      platformTheme = {
        name = "breeze";
        package = pkgs.kdePackages.breeze;
      };
      style = {
        name = "breeze";
        package = pkgs.kdePackages.breeze;
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
