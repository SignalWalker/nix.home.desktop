{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  theme = config.signal.desktop.theme;
  colors = theme.colors;
  signal = colors.signal;
  colorset = lib.types.submoduleWith {
    modules = [
      ({
        config,
        lib,
        name,
        ...
      }: let
        std = pkgs.lib;
        meta = config.__meta;
        colors = meta.pure;
      in {
        freeformType = with lib.types; attrsOf str;
        options = with lib; let
          mkFn = fn:
            mkOption {
              type = types.anything;
              readOnly = true;
              default = fn;
            };
        in {
          __meta = {
            pure = mkFn (foldl' (res: key:
              if (substring 0 1 key) == "_"
              then res
              else res // {${key} = config.${key};}) {} (attrNames config));
            css = {
              defines = mkFn (std.concatStringsSep "\n" (map (name: "@define-color ${name} #${colors.${name}};") (attrNames colors)));
              file = mkFn (pkgs.writeText "${name}.css" meta.css.defines);
            };
          };
        };
      })
    ];
  };
in {
  options = with lib; {
    signal.desktop.theme = {
      colors = mkOption {
        type = types.attrsOf colorset;
        default = {};
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = {
    signal.desktop.theme.colors = {
      signal = rec {
        black = "262626";
        white = "b7b7b7";
        red = "b62460";
        green = "1ea559";
        blue = "1877b7";
        # non-original
        light-white = "cdcdcd";
        dark-black = "060606";
        dark-grey = "4b4b4b";
        orange = "d79d34";
        yellow = "c6cc4b";
        cyan = "3dc1c4";
        indigo = "7833ce";
        violet = "c441bf";
        # semantic
        ## tracing
        error = red;
        warning = orange;
        info = yellow;
        debug = green;
        trace = blue;
        ## urgency
        low-priority = blue;
        normal-priority = light-white;
        urgent = yellow;
        critical = red;
        # ui
        bg-unfocused = dark-black;
        bg = black;
        bg-focused = dark-grey;
        fg-unfocused = white;
        fg = light-white;
        fg-link = cyan;
        fg-special = cyan;
        ## geometry
        border = white;
      };
    };
  };
  meta = {};
}
