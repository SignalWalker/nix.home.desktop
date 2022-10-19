{ config
, pkgs
, lib
, ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland.compositor;
  scratchpad = with lib;
    types.submoduleWith {
      modules = [
        ({ config, lib, pkgs, ... }: {
          options = with lib; {
            kb = mkOption {
              type = types.str;
            };
            criteria = mkOption {
              type = types.attrsOf (types.coercedTo (types.oneOf [ types.bool types.int ]) (toString) types.str);
              default = { };
            };
            resize = mkOption {
              type =
                let
                  dimsToStr = dims: "width ${toString (elemAt dims 0)} height ${toString (elemAt dims 1)}";
                in
                types.nullOr (types.coercedTo (types.either (types.listOf types.int) types.int) (e: dimsToStr (if isInt e then [ e e ] else e)) types.str);
              default = null;
            };
            center = mkOption {
              type = types.bool;
              default = true;
            };
            startup = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            # functions
            fn = let mkFn = fn: mkOption {
              type = types.anything;
              default = fn;
            }; in
              {
                sway_criteria = mkFn (let crit = { floating = "true"; } // config.criteria; in "[${foldl' (res: nxt: (if res == "" then res else res + " ") + "${nxt}=\"${crit.${nxt}}\"" ) "" (attrNames crit)}]");
                sway_show = mkFn ("${config.fn.sway_criteria} scratchpad show" + (if config.resize != null then ", resize set ${config.resize}" else "") + (if config.center then ", move position center" else ""));
                exec = mkFn (if config.startup == null then null else ("'${config.startup} || notify-send Scratchpad Failed to start'"));
              };
          };
          config = { };
        })
      ];
    };
in
{
  options.signal.desktop.wayland.compositor = with lib; {
    scratchpads = mkOption {
      type = types.listOf scratchpad;
      default = [ ];
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./compositor;
  config = {
    signal.desktop.wayland.compositor.scratchpads = [
      { kb = "Grave"; criteria = { app_id = "scratch_term"; }; resize = 75; startup = "kitty --class scratch_term"; }
      { kb = "Shift+D"; criteria = { class = "discord"; }; resize = 93; startup = "discordcanary"; }
      { kb = "Shift+F"; criteria = { app_id = "^firefox*"; }; resize = 93; startup = "firefox"; }
      { kb = "Shift+W"; criteria = { app_id = "cantata"; }; resize = 50; startup = "cantata"; }
      { kb = "Shift+V"; criteria = { app_id = "pavucontrol"; }; resize = 50; startup = "pavucontrol"; }
      { kb = "Shift+M"; criteria = { class = "Element"; }; resize = 93; startup = "element-desktop"; }
      { kb = "Shift+I"; criteria = { app_id = "scratch_irc"; }; resize = 93; startup = "kitty --class scratch_irc weechat"; }
      { kb = "Shift+T"; criteria = { app_id = "scratch_top"; }; resize = 75; startup = "kitty --class scratch_top btop"; }
      { kb = "Shift+/"; criteria = { app_id = "org.kde.dolphin"; }; resize = 75; startup = "dolphin"; }
    ];
    lib.signal.desktop.types = with lib; {
      inherit scratchpad;
    };
  };
}
