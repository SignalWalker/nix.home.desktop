{
  lib,
  ...
}:
let
  window = lib.types.submoduleWith {
    modules = [
      (
        {
          lib,
          name,
          config,
          ...
        }:
        {
          config = lib.mkIf (name != null) {
            inherit name;
          };
          options =
            let
              inherit (lib) types mkOption;
              # syntax: https://github.com/google/re2/wiki/Syntax
              regex = types.str;
              fullscreenState = types.enum [
                0
                1
                2
                3
              ];
              workspace = types.str;
              mkNullable =
                type: description:
                mkOption {
                  type = types.nullOr type;
                  inherit description;
                  default = null;
                };
              content = types.enum [
                "none"
                "photo"
                "video"
                "game"
              ];

              mkSubmodule =
                md:
                lib.types.submoduleWith {
                  modules = [ md ];
                };
              mkSubmoduleWithOpts =
                optFn:
                mkSubmodule (
                  { lib, ... }: {
                    options = optFn lib;
                  }
                );

              moveSizeDef = mkSubmoduleWithOpts (
                lib:
                let
                  inherit (lib) types mkOption;
                in
                {
                  x = mkOption {
                    type = types.str;
                  };
                  y = mkOption {
                    type = types.str;
                  };
                }
              );
              fullscreenStateClientInternal = mkSubmoduleWithOpts (
                lib:
                let
                  inherit (lib) mkOption;
                in
                {
                  client = mkOption {
                    type = fullscreenState;
                  };
                  internal = mkOption {
                    type = fullscreenState;
                  };
                }
              );

              monitorSetDef = mkSubmoduleWithOpts (
                lib:
                let
                  inherit (lib) types mkOption;
                in
                {
                  monitor = mkOption {
                    type = types.str;
                  };
                  silent = mkOption {
                    type = types.bool;
                    default = false;
                  };
                }
              );
              workspaceSetDef = mkSubmoduleWithOpts (
                lib:
                let
                  inherit (lib) types mkOption;
                in
                {
                  workspace = mkOption {
                    type = workspace;
                  };
                  silent = mkOption {
                    type = types.bool;
                    default = false;
                  };
                }
              );
              tagSetDef = mkSubmoduleWithOpts (
                lib:
                let
                  inherit (lib) types mkOption;
                in
                {
                  value = mkOption {
                    type = types.str;
                  };
                  action = mkOption {
                    type = types.enum [
                      "set"
                      "unset"
                      "toggle"
                    ];
                  };
                }
              );
              event = types.enum [
                "fullscreen"
                "maximize"
                "activate"
                "activatefocus"
                "fullscreenoutput"
              ];

              idleInhibit = types.enum [
                "none"
                "always"
                "focus"
                "fullscreen"
              ];
            in
            {
              name = mkOption {
                type = types.str;
              };
              criteria = {
                class = mkNullable regex "";
                title = mkNullable regex "";
                initialClass = mkNullable regex "";
                initialTitle = mkNullable regex "";
                tag = mkNullable types.str "";
                xwayland = mkNullable types.bool "";
                float = mkNullable types.bool "";
                fullscreen = mkNullable types.bool "";
                pin = mkNullable types.bool "";
                focus = mkNullable types.bool "";
                group = mkNullable types.bool "";
                modal = mkNullable types.bool "";
                fullscreenStateClient = mkNullable fullscreenState "";
                fullscreenStateInternal = mkNullable fullscreenState "";
                workspace = mkNullable workspace "";
                content = mkNullable content "";
                xdgTag = mkNullable regex "";
              };
              effects = {
                hypr = {
                  static = {
                    float = mkNullable types.bool "";
                    tile = mkNullable types.bool "";
                    fullscreen = mkNullable types.bool "";
                    maximize = mkNullable types.bool "";
                    fullscreenState = mkNullable fullscreenStateClientInternal "";
                    move = mkNullable moveSizeDef "";
                    size = mkNullable moveSizeDef "";
                    center = mkNullable types.bool "";
                    pseudo = mkNullable types.bool "pseudotile the window";
                    monitor = mkNullable monitorSetDef "";
                    workspace = mkNullable workspaceSetDef "";
                    noInitialFocus = mkNullable types.bool "";
                    pin = mkNullable types.bool "";
                    group = mkNullable types.str "";
                    suppressEvent = mkNullable event "";
                    content = mkNullable content "";
                    noCloseFor = mkNullable types.int "makes the window uncloseable by `killactive` for the given amount of time (ms)";
                    scrollingWidth = mkNullable types.float "set the column width (when opened in a scrolling layout)";
                  };
                  dynamic = {
                    persistentSize = mkNullable types.bool "";
                    noMaxSize = mkNullable types.bool "";
                    stayFocused = mkNullable types.bool "";
                    animation = mkNullable types.str "";
                    # borderColor = mkNullable types.
                    idleInhibit = mkNullable idleInhibit "";
                    # opacity = mkNul
                    tag = mkNullable tagSetDef "";
                    # maxSize = mkNullable
                    # minSize =
                    borderSize = mkNullable types.int "";
                    rounding = mkNullable types.int "";
                    roundingPower = mkNullable types.float "";
                    allowsInput = mkNullable types.bool "force an xwayland window to receive input even if it asks not to";
                    dimAround = mkNullable types.bool "";
                    decorate = mkNullable types.bool "";
                    focusOnActivate = mkNullable types.bool "";
                    keepAspectRatio = mkNullable types.bool "";
                    nearestNeighbor = mkNullable types.bool "";
                    noAnim = mkNullable types.bool "";
                    noBlur = mkNullable types.bool "";
                    noDim = mkNullable types.bool "";
                    noFocus = mkNullable types.bool "";
                    noFollowMouse = mkNullable types.bool "";
                    noShadow = mkNullable types.bool "";
                    noShortcutsInhibit = mkNullable types.bool "";
                    noScreenShare = mkNullable types.bool "";
                    noVrr = mkNullable types.bool "";
                    noAutoHdr = mkNullable types.bool "";
                    opaque = mkNullable types.bool "";
                    forceRgbx = mkNullable types.bool "";
                    syncFullscreen = mkNullable types.bool "";
                    immediate = mkNullable types.bool "";
                    xray = mkNullable types.bool "";
                    renderUnfocused = mkNullable types.bool "";
                    scrollMouse = mkNullable types.float "";
                    scrollTouchpad = mkNullable types.float "";
                    confinePointer = mkNullable types.bool "";
                    tonemap = mkNullable (types.enum [
                      "on"
                      "off"
                      "clamp"
                      "limited"
                    ]) "";
                  };
                };
              };
              hypr = {
                lua = lib.mkOption {
                  type = types.str;
                  readOnly = true;
                  default =
                    let
                      toLua = lib.generators.toLua { };
                      toSnakeCase =
                        let
                          inherit (lib)
                            isString
                            typeOf
                            splitStringBy
                            match
                            toLower
                            addContextFrom
                            concatMapStringsSep
                            ;
                        in
                        str:
                        lib.throwIfNot (isString str) "toSnakeCase only accepts string values, but got ${typeOf str}" (
                          let
                            isUpper = c: match "[[:upper:]]" c != null;
                            parts = splitStringBy (prev: curr: isUpper curr) true str;
                          in
                          concatMapStringsSep "_" (part: addContextFrom str (toLower part)) parts
                        );
                      filterNull = lib.filterAttrs (key: val: val != null);
                      matchRules = lib.mapAttrs' (key: val: {
                        name = toSnakeCase key;
                        value = val;
                      }) (filterNull config.criteria);
                      effectRules =
                        let
                          toEffects =
                            set:
                            lib.mapAttrs' (key: val: {
                              name = toSnakeCase key;
                              value = val;
                            }) (filterNull set);
                        in
                        (toEffects config.effects.hypr.static) // (toEffects config.effects.hypr.dynamic);
                      args = toLua (
                        effectRules
                        // {
                          name = config.name;
                          match = matchRules;
                        }
                      );
                    in
                    "hl.window_rule(${args})";
                };
              };
            };
        }
      )
    ];
  };
in
{
  options =
    let
      inherit (lib) mkOption types;
    in
    {
      desktop.windows = mkOption {
        type = types.attrsOf window;
        default = { };
      };
    };
  config = {
    desktop.windows = {
      fullscreenInhibitsIdle = {
        criteria = {
          focus = true;
        };
        effects = {
          hypr.dynamic.idleInhibit = "fullscreen";
        };
      };
      floatModals = {
        criteria = {
          modal = true;
        };
        effects = {
          hypr.static.float = true;
        };
      };
    };
  };
  meta = { };
}
