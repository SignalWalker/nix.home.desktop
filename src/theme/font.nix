{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  fcfg = config.signal.desktop.theme.font;
  fonts = fcfg.fonts;
  sTypes = fcfg.types;
  iosevka = fonts.iosevka;
  iFams = iosevka.families;
  sarasa = fonts.sarasa;
  sFams = sarasa.families;
  isMatch = regex: str: (match regex str) != null;
  matchFamNames = regex: set:
    foldl' (
      res: key: let
        fam = set.${key};
      in
        res ++ (std.optional (isMatch regex fam.name) fam)
    ) [] (attrNames set);
  sarasaUi = matchFamNames "Sarasa UI .*" sFams;
in {
  options = with lib; let
    fontType = sTypes.font;
    familyType = sTypes.fontFamily;
  in {
    signal.desktop.theme.font = {
      fonts = mkOption {
        type = types.attrsOf fontType;
        default = {};
      };
      mono = mkOption {
        type = types.listOf familyType;
        default =
          [
            iFams."Iosevka"
          ]
          ++ (matchFamNames "Sarasa Mono .*" sFams);
      };
      terminal = mkOption {
        type = types.listOf familyType;
        default =
          [
            iFams."Iosevka Term"
          ]
          ++ (matchFamNames "Sarasa Term .*" sFams);
      };
      sans = mkOption {
        type = types.listOf familyType;
        default =
          [
            iFams."Iosevka Aile"
          ]
          ++ sarasaUi;
      };
      slab = mkOption {
        type = types.listOf familyType;
        default =
          [
            iFams."Iosevka Etoile"
          ]
          ++ sarasaUi;
      };
      symbols = mkOption {
        type = types.listOf familyType;
        default = [
          fonts.font-awesome.families.default
          fonts.symbola.families.default
          fonts.openmoji.families."OpenMoji Black"
          fonts.openmoji.families."OpenMoji Color"
        ];
      };
      bmp = mkOption {
        type = types.listOf familyType;
        default =
          [
            fonts.cozette.families."Cozette"
            fonts.spleen.families.default
            fonts.scientifica.families.default
            fonts.curie.families.default
          ]
          ++ (attrValues fonts.tamzen.families)
          ++ [
            fonts.gohu.families.default
            fonts.siji.families.default
            fonts.siji.families."Wuncon Siji"
          ];
      };
      bmpSizes = mkOption {
        type = types.attrsOf (types.listOf familyType);
        readOnly = true;
        default = foldl' (res: bmp: let
          sizeStrs = map (size: toString size) bmp.pixelsizes;
        in
          res // (std.genAttrs sizeStrs (size: (res.${size} or []) ++ [bmp]))) {}
        fcfg.bmp;
      };
      bmpsAt = mkOption {
        type = types.functionTo (types.listOf familyType);
        readOnly = true;
        default = size: fcfg.bmpSizes.${toString size} or [];
      };
      bmpsIn = mkOption {
        type = types.functionTo (types.listOf familyType);
        readOnly = true;
        default = sizes: foldl' (acc: size: acc ++ (fcfg.bmpsAt size)) [] sizes;
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = {
    fonts.fontconfig.enable = true;
    gtk.font = let
      font = head fcfg.sans;
    in {
      inherit (font) package;
      name = font.name;
    };
    signal.desktop.theme.font = {
      fonts = {
        spleen = {
          package = pkgs.spleen;
          families = {
            "Spleen" = {
              pixelsizes = [8 12 16 24 32 64];
              formats = ["CFF" "BDF" "PCF"];
            };
          };
        };
        tamzen = {
          package = pkgs.tamzen;
          families = let
            pixelsizes = [9 12 13 14 15 16 20];
            styles = ["Regular" "Bold"];
          in {
            Tamzen = {
              inherit pixelsizes styles;
              formats = ["TrueType"];
            };
            "Misc Tamzen" = {
              inherit pixelsizes styles;
              formats = ["PCF"];
            };
            TamzenForPowerline = {
              inherit pixelsizes styles;
              formats = ["TrueType"];
            };
            "Misc TamzenForPowerline" = {
              inherit pixelsizes styles;
              formats = ["PCF"];
            };
          };
        };
        cozette = {
          package = pkgs.cozette;
          families = {
            Cozette = {
              pixelsizes = [13];
              styles = ["Regular" "Medium"];
              formats = ["TrueType" "BDF"];
            };
            CozetteVector = {
              styles = ["Regular"];
              formats = ["TrueType" "CFF"];
            };
          };
        };
        siji = {
          package = pkgs.siji;
          families = rec {
            Siji = {
              pixelsizes = [10];
              styles = ["Regular"];
              formats = ["TrueType"];
            };
            "Wuncon Siji" = {
              pixelsizes = [10];
              styles = ["Regular"];
              formats = ["PCF"];
            };
            default = Siji;
          };
        };
        gohu = {
          package = pkgs.gohufont;
          families = {
            GohuFont = {
              pixelsizes = [11 14];
              formats = ["TrueType"];
              styles = ["Regular" "Bold"];
            };
          };
        };
        scientifica = {
          package = pkgs.scientifica;
          families = {
            scientifica = {
              formats = ["TrueType" "BDF"];
              styles = ["Regular" "Bold" "Italic"];
              pixelsizes = [11];
            };
          };
        };
        curie = {
          package = pkgs.curie;
          families = {
            curie = {
              formats = ["TrueType"];
              styles = ["Medium" "Bold" "Italic"];
              pixelsizes = [12];
            };
          };
        };
        font-awesome = {
          package = pkgs.font-awesome;
          families = rec {
            free = {
              name = "Font Awesome 6 Free";
              styles = ["Regular" "Solid"];
              formats = ["CFF"];
            };
            free-regular =
              free
              // {
                name = "Font Awesome 6 Free Regular";
                styles = ["Regular"];
              };
            free-solid =
              free
              // {
                name = "Font Awesome 6 Free Solid";
                styles = ["Solid"];
              };
            brands = {
              name = "Font Awesome 6 Brands";
              styles = ["Regular"];
              formats = ["CFF"];
            };
            default = free;
          };
        };
        symbola = {
          package = pkgs.symbola;
          families = {
            symbola = {
              formats = ["TrueType"];
              styles = ["Regular"];
            };
          };
        };
        openmoji = {
          package = pkgs.openmoji-black;
          families = {
            "OpenMoji" = {
              formats = ["TrueType"];
              styles = ["Regular" "Black" "Color"];
            };
            "OpenMoji Black" = {
              package = pkgs.openmoji-black;
              formats = ["TrueType"];
              styles = ["Regular" "Black"];
            };
            "OpenMoji Color" = {
              package = pkgs.openmoji-color;
              formats = ["TrueType"];
              styles = ["Regular" "Color"];
            };
          };
        };
        # iosevka-signal = let
        #   basePlan = {
        #     family = "Iosevka Signal";
        #     spacing = "normal";
        #     serifs = "sans";
        #     no-cv-ss = false;
        #     ligations.inherits = "dlig";
        #   };
        #   plans = {
        #     Mono = {};
        #     FcMono = {spacing = "fontconfig-mono";};
        #     Term = {
        #       spacing = "term";
        #       export-glyph-names = config.programs.kitty.enable;
        #     };
        #     Sans = {spacing = "quasi-proportional";};
        #     Slab = {
        #       spacing = "quasi-proportional";
        #       serifs = "slab";
        #     };
        #   };
        # in
        #   std.mapAttrs' (name: planExt: let
        #     nameL = std.toLower name;
        #     family = "Iosevka Signal ${name}";
        #     plan = basePlan // planExt // {inherit family;};
        #   in
        #     nameValuePair "${nameL}" {
        #       package = pkgs.iosevka.override {
        #         set = "signal-${nameL}";
        #         privateBuildPlan = plan;
        #       };
        #       inherit family;
        #       formats = ["TrueType"];
        #       styles = ["Regular" "Bold" "Oblique" "Italic"];
        #     })
        #   plans;
        iosevka = let
          varBase = {
            formats = ["TrueType"];
            styles = ["Regular" "Bold" "Oblique" "Italic"];
          };
        in {
          package = pkgs.iosevka-bin;
          families = {
            Iosevka = varBase // {};
            "Iosevka Term" = varBase // {};
            "Iosevka Aile" =
              varBase
              // {
                package = pkgs.iosevka-bin.override {variant = "aile";};
              }; # sans serif
            "Iosevka Etoile" =
              varBase
              // {
                package = pkgs.iosevka-bin.override {variant = "etoile";};
              }; # slab serif
          };
        };
        sarasa = let
          langs = ["CL" "SC" "TC" "HC" "J" "K"];
          usages = ["Mono" "UI" "Term"];
          base = {
            formats = ["TrueType"];
            styles = ["Regular" "Bold" "Italic"];
          };
        in {
          package = pkgs.sarasa-gothic;
          families = foldl' (uAcc: usage:
            uAcc
            // (foldl' (lAcc: lang:
              lAcc
              // {
                "Sarasa ${usage} ${lang}" = base;
              }) {}
            langs)) {}
          usages;
        };
      };
    };
  };
  meta = {};
}
