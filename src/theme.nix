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
        package = pkgs.breeze-icons;
        name = "Breeze";
      };
      theme = {
        package = pkgs.breeze-gtk;
        name = "Breeze";
      };
    };
    # home.packages = with pkgs; [
    #   libsForQt5.qtstyleplugin-kvantum
    #   themechanger
    # ];
    qt = {
      enable = true;
      # platformTheme = "gtk";
      style = {
        package = pkgs.breeze-qt5;
        name = "breeze";
      };
    };
    xdg.configFile."kdeglobals".text = ''
    '';
    # xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    #   theme=KvArcDark
    # '';
    home.pointerCursor = {
      # package = pkgs.nordzy-cursor-theme;
      # package = pkgs.quintom-cursor-theme;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      gtk.enable = true;
      x11.enable = true;
      size = 24;
    };
    systemd.user.services."xsettings" = {
      Unit = {
        PartOf = ["graphical-session.target"];
        Before = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session-pre.target"];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
      };
    };
  };
}
