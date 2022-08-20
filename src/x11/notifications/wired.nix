{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.x11;
  ncfg = cfg.notifications;
  wcfg = cfg.wired;
  typeOf = obj:
    if isInt obj
    then "int"
    else if std.isDerivation obj
    then "derivation"
    else if isString
    then "str"
    else if (obj == true || obj == false)
    then "bool"
    else if obj == null
    then "null"
    else if isList obj
    then "list"
    else if isAttrs obj
    then (obj.__type or "attrset")
    else if isFunction obj
    then "function"
    else if isFloat obj
    then "float"
    else abort "typeOf: couldn't find type of ${std.toPretty {} obj}";
  tyToRON = let
    cleanAttrs = attrs: removeAttrs attrs ["__type"];
    concatCommas = std.concatStringsSep ", ";
    mapToList = std.mapAttrsToList;
    aMapToCommas = f: a: concatCommas (mapToList f a);
    lMapToCommas = f: a: concatCommas (map f a);
  in
    rec {
      base = {
        any = a: base.${typeOf a} a;
        mapEntry = name: val: "\"${name}\": ${base.any val}";
        structEntry = name: val: "${name}: ${base.any val}";
        int = i: "${i}";
        derivation = d: abort "cannot convert derivation to RON";
        str = str: "\"${str}\"";
        bool = bool:
          if bool
          then "true"
          else "false";
        null = n: "None";
        function = d: abort "cannot convert function to RON";
        float = f: "${f}";
        list = l: "[" + (lMapToCommas base.any l) + "]";
        map = b: let m = b.__value; in "{" + (aMapToCommas base.mapEntry m) + "}";
        struct = b: let s = b.__value; in "${b.__class or ""}(" + (aMapToCommas base.structEntry s) + ")";
        tuple = b: let t = b.__value; in "${b.__class or ""}(" + (lMapToCommas base.any t) + ")";
        class = b: b.__value;
        attrset = a: base.map {__value = a;};
        some = s: "Some(${base.any s.__value})";
        none = base.null;
      };
    }
    .base;
  mkType = __type: __value: {inherit __type __value;};
  mkType' = __type: __value: __class: (mkType __type __value) // {inherit __class;};
  rMap = mkType "map";
  tuple = mkType "tuple";
  struct = mkType "struct";
  rMap' = class: attrs: (rMap attrs) // {__class = class;};
  tuple' = class: list: (tuple list) // {__class = class;};
  struct' = class: attrs: (struct attrs) // {__class = class;};
  some = mkType "some";
  none = null;
  toRON = tyToRON.any;

  class = mkType "class";

  color = r: g: b: a: struct' "Color" {inherit r g b a;};
  hex = h: struct' "Color" {hex = h;};
in {
  options.signal.desktop.x11.notifications.wired = with lib; {};
  imports = [];
  config = lib.mkIf (cfg.enable && (ncfg.backend == "wired")) {
    services.wired = {
      enable = true;
      config = ./wired/wired.ron;
      #config = pkgs.writeText "wired.ron" (toRON (struct {
      #  max_notifications = 0;
      #  timeout = 10000;
      #  poll_interval = 16;
      #  #idle_threshold = 3600;
      #  replacing_enabled = true;
      #  replacing_resets_timeout = true;
      #  closing_enabled = true;
      #  history_length = 20;
      #  focus_follows = "Mouse";
      #  # print_to_file = "/tmp/wired.log";
      #  # min_window_width = 1;
      #  # min_window_height = 1;
      #  debug = false;
      #  debug_color = color 0.0 1.0 0.0 1.0;
      #  debug_color_alt = color 1.0 0.0 0.0 1.0;
      #  layout_blocks = let
      #    hook' = struct' "Hook";
      #    hook = p: s:
      #      hook' {
      #        parent_anchor = class p;
      #        self_anchor = class s;
      #      };
      #    vec2 = x: y: struct' "Vec2" {inherit x y;};
      #    padding = left: right: top: bottom: struct' "Padding" {inherit left right top bottom;};
      #    dims = wmin: wmax: hmin: hmax:
      #      struct {
      #        width = struct {
      #          min = wmin;
      #          max = wmax;
      #        };
      #        height = struct {
      #          min = hmin;
      #          max = hmax;
      #        };
      #      };
      #  in [
      #    (struct {
      #      name = "root_image";
      #      parent = "";
      #      hook = hook "TL" "TL";
      #      offset = vec2 7.0 7.0;
      #      render_criteria = [(class "HintImage")];
      #      params = tuple' "NotificationBlock" [
      #        (struct {
      #            monitor = 0;
      #            border_width = 3.0;
      #            border_rounding = 3.0;
      #            border_color = hex "#ebdbb2";
      #            border_color_low = hex "#282828";
      #            border_color_critical = hex "#fb4934";
      #            border_color_paused = hex "#fabd2f";
      #            gap = vec2 0.0 8.0;
      #            notification_hook = hook "BL" "TL";
      #          })
      #      ];
      #    })
      #    (struct {
      #      name = "image";
      #      parent = "root_image";
      #      hook = hook "TL" "TL";
      #      offset = vec2 0.0 0.0;
      #      params = tuple' "ImageBlock" [
      #        (struct
      #          {
      #            image_type = class "Hint";
      #            padding = padding 7.0 0.0 7.0 7.0;
      #            rounding = 3.0;
      #            scale_width = 48;
      #            scale_height = 48;
      #            filter_mode = class "Lanczos3";
      #          })
      #      ];
      #    })
      #    (struct {
      #      name = "summary_image";
      #      parent = "image";
      #      hook = hook "MR" "BL";
      #      offset = vec2 0.0 0.0;
      #      params = tuple' "TextBlock" [
      #        (
      #          struct
      #          {
      #            text = "%s";
      #            font = "Arial Bold 11";
      #            ellipsize = class Middle;
      #            color = hex "#ebdbb2";
      #            color_hovered = hex "#fbf1c7";
      #            padding = padding 7.0 7.0 7.0 0.0;
      #            dimensions = dims 50 150 0 0;
      #          }
      #        )
      #      ];
      #    })
      #  ];
      #}));
    };
  };
}
