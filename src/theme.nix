{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.theme;
  fcfg = cfg.font;
  sTypes = config.lib.signal.types;
in {
  options.signal.desktop.theme = with lib; {
    font = let
      spleen = {
        package = pkgs.spleen;
        family = "Spleen";
        pixelsizes = [8 12 16 24 32 64];
        formats = ["CFF" "BDF" "PCF"];
      };
      tamzen = {
        package = pkgs.tamzen;
        pixelsizes = [9 12 13 14 15 16 20];
        formats = ["TrueType" "BDF"];
        styles = ["Regular" "Bold"];
      };
      tamzenForPowerline =
        tamzen
        // {
          family = "TamzenForPowerline";
        };
      cozette = {
        package = pkgs.cozette;
        family = "Cozette";
        pixelsizes = [13];
        formats = ["TrueType" "BDF"];
      };
      cozettevector = {
        package = pkgs.cozette;
        family = "CozetteVector";
        formats = ["TrueType" "CFF"];
      };
      siji = {
        package = pkgs.siji;
        family = "Siji";
        formats = ["TrueType" "PCF"];
        pixelsizes = [10];
      };
      gohu = {
        package = pkgs.gohufont;
        family = "GohuFont";
        pixelsizes = [11 14];
        formats = ["TrueType"];
        styles = ["Regular" "Bold"];
      };
      scientifica = {
        package = pkgs.scientifica;
        family = "scientifica";
        formats = ["TrueType" "BDF"];
        styles = ["Regular" "Bold" "Italic"];
        pixelsizes = [11];
      };
      curie = {
        package = pkgs.curie;
        family = "curie";
        formats = ["TrueType"];
        styles = ["Medium" "Bold" "Italic"];
        pixelsizes = [12];
      };
      symbola = {
        family = "symbola";
        package = pkgs.symbola;
      };
      openmoji-black = {
        family = "openmoji";
        package = pkgs.openmoji-black;
        styles = ["Black"];
      };
      openmoji-color = {
        family = "openmoji";
        package = pkgs.openmoji-color;
        styles = ["Color"];
      };
      iosevka-signal = let
        basePlan = {
          family = "Iosevka Signal";
          spacing = "normal";
          serifs = "sans";
          no-cv-ss = false;
          ligations.inherits = "dlig";
        };
        plans = {
          Mono = {};
          FcMono = {spacing = "fontconfig-mono";};
          Term = {
            spacing = "term";
            export-glyph-names = config.programs.kitty.enable;
          };
          Sans = {spacing = "quasi-proportional";};
          Slab = {
            spacing = "quasi-proportional";
            serifs = "slab";
          };
        };
      in
        std.mapAttrs' (name: planExt: let
          nameL = std.toLower name;
          family = "Iosevka Signal ${name}";
          plan = basePlan // planExt // { inherit family; };
        in
          nameValuePair "${nameL}" {
            package = pkgs.iosevka.override {
              set = "signal-${nameL}";
              privateBuildPlan = plan;
            };
            inherit family;
            formats = ["TrueType"];
            styles = ["Regular" "Bold" "Oblique" "Italic"];
          })
        plans;
      iosevka = let
        varBase = {
          package = pkgs.iosevka-bin;
          formats = [ "TrueType" ];
          styles = [ "Regular" "Bold" "Oblique" "Italic" ];
        };
      in {
        mono = varBase // { family = "Iosevka"; };
        term = varBase // { family = "Iosevka Term"; };
        sans = varBase // {
          package = pkgs.iosevka-bin.override { variant = "aile"; };
          family = "Iosevka Aile";
        };
        slab = varBase // {
          package = pkgs.iosevka-bin.override { variant = "etoile"; };
          family = "Iosevka Etoile";
        };
      };
      sarasa = let
        langs = ["CL" "SC" "TC" "HC" "J" "K"];
        usages = ["Mono" "UI" "Term"];
        base = {
          package = pkgs.sarasa-gothic;
          formats = ["TrueType"];
          styles = ["Regular" "Bold" "Italic"];
        };
      in
        foldl' (uAcc: usageName: let
          usageL = std.toLower usageName;
        in
          uAcc
          // {
            "${usageL}" = foldl' (lAcc: langName: let
              langL = std.toLower langName;
            in
              lAcc
              // {
                "${langL}" = base // {family = "Sarasa ${usageName} ${langName}";};
              }) {}
            langs;
          }) {}
        usages;
    in {
      mono = mkOption {
        type = types.listOf sTypes.font;
        default =
          [
            iosevka.mono
          ]
          ++ (attrValues sarasa.mono);
      };
      terminal = mkOption {
        type = types.listOf sTypes.font;
        default =
          [
            iosevka.term
          ]
          ++ (attrValues sarasa.term);
      };
      sans = mkOption {
        type = types.listOf sTypes.font;
        default =
          [
            iosevka.sans
          ]
          ++ (attrValues sarasa.ui);
      };
      slab = mkOption {
        type = types.listOf sTypes.font;
        default =
          [
            iosevka.slab
          ]
          ++ (attrValues sarasa.ui);
      };
      symbols = mkOption {
        type = types.listOf sTypes.font;
        default = [
          symbola
          openmoji-black
          openmoji-color
        ];
      };
      bmp = mkOption {
        type = types.listOf sTypes.font;
        default = [
          cozette
          spleen
          scientifica
          curie
          tamzen
          tamzenForPowerline
          gohu
          siji
        ];
      };
    };
  };
  imports = lib.signal.fs.listFiles ./theme;
  config = {
    # home.packages = map (font: font.package) (fcfg.sans ++ fcfg.slab ++ fcfg.mono ++ fcfg.terminal ++ fcfg.bmp ++ fcfg.symbols);
    fonts.fontconfig.enable = true;
    gtk = {
      enable = true;
      font = let
        font = head cfg.font.sans;
      in {
        inherit (font) package;
        name = font.family;
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
  };
}
