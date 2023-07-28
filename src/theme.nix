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
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3 = {
        bookmarks = map (dir: "file:///${dir}") (std.attrValues config.xdg.userDirs.extraConfig);
      };
      iconTheme = {
        package = pkgs.breeze-icons;
        name = "Breeze";
      };
      theme = let
        size = "Compact";
        variant = "Frappe";
        accent = "Teal";
      in {
        package = pkgs.catppuccin-gtk.override {
          accents = [(lib.toLower accent)];
          size = lib.toLower size;
          tweaks = [];
          variant = lib.toLower variant;
        };
        name = "Catppuccin-${variant}-${size}-${accent}-dark";
      };
    };
    # home.packages = with pkgs; [
    #   libsForQt5.qtstyleplugin-kvantum
    #   themechanger
    # ];
    qt = {
      enable = true;
      platformTheme = "gtk";
      # style = {
      #   package = pkgs.breeze-qt5;
      #   name = "breeze";
      # };
    };
    xdg.configFile."kdeglobals".text = ''
    '';
    # xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    #   theme=KvArcDark
    # '';
    home.pointerCursor = {
      # package = pkgs.nordzy-cursor-theme;
      # package = pkgs.quintom-cursor-theme;
      package = pkgs.catppuccin-cursors.frappeDark;
      name = "Catppuccin-Frappe-Dark-Cursors";
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
