{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  tlib = config.lib.signal.types;
  dlib = config.lib.signal.desktop;
  tcfg = config.signal.desktop.theme;
in {
  options = with lib; {};
  imports = [];
  config = {
    lib.signal.types = with lib; {
      font = types.submoduleWith {
        modules = [
          ({config, ...}: {
            options = {
              package = mkOption {type = types.package;};
              family = mkOption {
                type = types.str;
                default = assert config.package ? pname; config.package.pname;
              };
              formats = mkOption {
                type = types.listOf types.str;
                default = [];
              };
              pixelsizes = mkOption {
                type = types.nullOr (types.listOf types.int);
                default = null;
              };
              styles = mkOption {
                type = types.listOf types.str;
                default = [];
              };
              slants = mkOption {
                type = types.listOf types.int;
                default = [];
              };
              weights = mkOption {
                type = types.listOf types.int;
                default = [];
              };
            };
          })
        ];
      };
      fontInst = types.submoduleWith {
        modules = [
          ({config, ...}: {
            options = let
              mkFontOpt = baseName: let
                base = config.font.${baseName};
              in
                mkOption {
                  type = types.nullOr (types.enum base);
                  default =
                    if base == []
                    then null
                    else head base;
                };
              mkNullOpt = type:
                mkOption {
                  type = types.nullOr type;
                  default = null;
                };
            in {
              font = mkOption {type = tlib.font;};
              style = mkFontOpt "styles";
              format = mkFontOpt "formats";
              size = let
                pSizes = config.font.pixelsizes;
              in
                mkOption {
                  type = types.nullOr (
                    if pSizes == null
                    then types.int
                    else (types.enum pSizes)
                  );
                  default =
                    if pSizes == null
                    then null
                    else head pSizes;
                };
              pixelsize = let
                pSizes = config.font.pixelsizes;
              in
                mkOption {
                  type = types.nullOr (
                    if pSizes == null
                    then types.int
                    else (types.enum pSizes)
                  );
                  default =
                    if pSizes == null
                    then null
                    else head pSizes;
                };
              antialias = let
                pSizes = config.font.pixelsizes;
              in
                mkOption {
                  type = types.nullOr types.bool;
                  default =
                    if pSizes == null
                    then null
                    else false;
                };
            };
          })
        ];
      };
    };
    lib.signal.desktop.theme = with lib; {
      font = {
        selectSize = {
          font,
          ideal,
        }: let
          abs = val:
            if val < 0
            then val * -1
            else val;
        in
          if font.pixelsizes != null
          then
            (foldl' (res: val:
              if res == [] || ((abs (ideal - val)) < (abs (ideal - res)))
              then val
              else res) []
            font.pixelsizes)
          else ideal;
      };
      bmpSizeMap = let
        bmp = tcfg.font.bmp;
      in
        foldl' (
          acc: font:
            assert font.pixelsizes != null;
              acc // (std.genAttrs (map toString font.pixelsizes)) (psize: (acc.${psize} or []) ++ [font])
        ) {}
        bmp;
      bmpPatternMap = let
        sMap = dlib.theme.bmpSizeMap;
      in
        std.mapAttrs (pixelsize: fonts: map (font: dlib.theme.fontToFcPattern {inherit font pixelsize;}) fonts) dlib.theme.bmpSizeMap;

      bmpsAt = pixelsize: dlib.theme.bmpSizeMap.${toString pixelsize} or []; # foldl' (acc: font: acc ++ (std.optional (font.pixelsizes != null && elem pixelsize font.pixelsizes) font)) [] tcfg.font.bmp;
      bmpsIn = pixelsizes: foldl' (acc: pSize: acc ++ (dlib.theme.bmpsAt pSize)) [] pixelsizes;
      bmpPatternsAt = pixelsize: dlib.theme.bmpPatternMap.${toString pixelsize} or []; # map (font: dlib.theme.fontToFcPattern {inherit font pixelsize;}) (bmpsAt pixelSize);
      bmpPatternsIn = pixelsizes: foldl' (acc: pSize: acc ++ (dlib.theme.bmpPatternsAt pSize)) [] pixelsizes;

      fontToInst = font: opts: {inherit font;} // opts;
      fontToFcPattern = inst @ {font, ...}: let
        keyMap = {
          "format" = "fontformat";
        };
        mkEntry = fInst: name: assert name != "font"; let fcName = keyMap.${name} or name; in "${fcName}=${toString fInst.${name}}";
        mkEntries = fInst: foldl' (acc: key: acc ++ (std.optional (key != "font" && fInst.${key} != null) (mkEntry fInst key))) [] (attrNames fInst);
      in
        "${font.family}:"
        + (
          concatStringsSep "," (mkEntries inst)
        );
    };
  };
}
