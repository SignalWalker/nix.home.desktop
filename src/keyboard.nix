{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  T = lib.types;
  foldBy = fnSet: vSet: vRem:
    std.foldl
    (acc: nxt: acc ++ (fnSet.${nxt} or fnSet.__default) vSet.${nxt})
    []
    (attrNames (removeAttrs vSet vRem));
  format = {
    include = includes: [("include \"" + (concatStringsSep "+" includes) + "\"")];
    __default = s: [s];
  };
  genSection = {
    __default = ksec @ {xkbTag, ...}:
      [
        "${xkbTag} {"
      ]
      ++ (map (s: "\t" + s) (foldBy format ksec ["xkbTag"]))
      ++ [
        "};"
      ];
  };
  toXKBMap = kmap @ {
    keycodes,
    types,
    compat,
    symbols,
    geometry,
  }:
    concatStringsSep "\n" ([
        "xkb_keymap {"
      ]
      ++ (map (s: "\t" + s) (foldBy genSection kmap []))
      ++ [
        "};"
      ]);
in {
  imports = lib.signal.fs.path.listFilePaths ./keyboard;
  options.services.X11.xkeymap = with lib; let
    mkXKBModule = xkbTag: opts @ {...}:
      T.submodule {
        options =
          {
            include = mkOption {
              type = T.listOf T.str;
              default = [];
            };
          }
          // opts
          // {
            xkbTag = mkOption {
              type = T.str;
              default = xkbTag;
            };
          };
      };
    keycodeSubmodule = mkXKBModule "xkb_keycodes" {};
    typesSubmodule = mkXKBModule "xkb_types" {};
    compatSubmodule = mkXKBModule "xkb_compat" {};
    symbolsSubmodule = mkXKBModule "xkb_symbols" {};
    geometrySubmodule = mkXKBModule "xkb_geometry" {};
  in
    mkOption {
      type = T.nullOr (T.submodule {
        options = {
          keycodes = mkOption {type = keycodeSubmodule;};
          types = mkOption {type = typesSubmodule;};
          compat = mkOption {type = compatSubmodule;};
          symbols = mkOption {type = symbolsSubmodule;};
          geometry = mkOption {type = geometrySubmodule;};
        };
      });
      default = null;
    };
  config = let
    cfg = config.services.X11.xkeymap;
  in
    lib.mkIf (cfg != null) {
      xdg.configFile."xkeymap" = {
        text = toXKBMap cfg;
        target = "xkeymap";
      };
      # systemd.user.services.setxkbmap.Service.ExecStart = lib.mkForce "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${cfg.outputPath} $DISPLAY";
    };
}
