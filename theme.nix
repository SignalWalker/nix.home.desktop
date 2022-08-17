{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.theme;
in {
  options.theme = with lib; {
    enable = mkEnableOption "theme settings";
    font = let
      fontMod = types.submodule {
        options = {
          name = mkOption {type = types.str;};
          package = mkOption {type = types.package;};
          style = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          weight = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          usage = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          format = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          size = mkOption {
            type = types.nullOr types.int;
            default = null;
          };
        };
      };
      mkFontOption = default:
        mkOption {
          type = fontMod;
          inherit default;
        };
      iosevka = {
        name = "Iosevka";
        package = pkgs.iosevka-bin;
      };
      sarasa = {
        name = "Sarasa";
        package = pkgs.sarasa-gothic;
      };
      spleen = {
        name = "spleen";
        package = pkgs.spleen;
      };
      tamzen = {
        name = "tamzen";
        package = pkgs.tamzen;
      };
      cozette = {
        name = "cozette";
        package = pkgs.cozette;
      };
      siji = {
        name = "siji";
        package = pkgs.siji;
      };
      symbola = {
        name = "symbola";
        package = pkgs.symbola;
      };
      openmoji-black = {
        name = "openmoji";
        package = pkgs.openmoji-black;
      };
      openmoji-color = {
        name = "openmoji";
        package = pkgs.openmoji-color;
        style = "color";
      };
    in {
      mono = mkFontOption iosevka;
      sans = mkFontOption iosevka;
      serif = mkFontOption iosevka;
      cjk = mkFontOption sarasa;
      bmp = let
        mkBmp = default: size: opts: default // {inherit size;} // opts;
      in
        mkOption {
          type = types.attrsOf fontMod;
          default = {
            "5" = mkBmp spleen 5 {};
            "8" = mkBmp spleen 8 {};
            # "9" = mkBmp tamzen 9 {format = "BDF";};
            "12" = mkBmp spleen 12 {};
            "13" = mkBmp cozette 13 {};
            "16" = mkBmp spleen 16 {};
            "24" = mkBmp spleen 24 {};
            "32" = mkBmp spleen 32 {};
            "64" = mkBmp spleen 64 {};
          };
        };
      icons = {
        color = mkFontOption openmoji-color;
        monochrome = mkFontOption openmoji-black;
        bmp = mkOption {
          type = types.attrsOf fontMod;
          default = let
            mkBmp = default: size: opts: default // {inherit size;} // opts;
          in {
            "8" = mkBmp siji 8 {};
          };
        };
      };
    };
  };
  imports = [];
  config = lib.mkMerge [
    {
      # lib.theme.selAttrs = set: keys: foldl' (acc: key: acc // { ${key} = set.${key}; }) {} keys;
    }
    (lib.mkIf cfg.enable {
      home.packages = map (font: font.package) ([
          cfg.font.sans
          cfg.font.serif
          cfg.font.mono
          cfg.font.icons.color
          cfg.font.icons.monochrome
        ]);
        # ++ (attrValues cfg.font.bmp)
        # ++ (attrValues cfg.font.icons.bmp));
      fonts.fontconfig.enable = true;
      gtk = {
        enable = true;
        font = let font = config.theme.font.sans; in {
          inherit (font) name package;
        };
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
    })
  ];
}
