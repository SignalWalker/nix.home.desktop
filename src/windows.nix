{
  config,
  pkgs,
  lib,
  ...
}:
let

  window = lib.types.submoduleWith {
    modules = [
      (
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          options =
            let
              inherit (lib) mkOption types mkEnableOption;
              regex = types.str;
              fullscreenState = types.enum [
                "none"
                "maximize"
                "fullscreen"
                "maximize_and_fullscreen"
              ];
              content = types.enum [
                "none"
                "photo"
                "video"
                "game"
              ];
            in
            {
              name = mkOption {
                type = types.str;
              };
              criteria = {
                appId = mkOption {
                  type = types.nullOr regex;
                  default = null;
                };
                class = mkOption {
                  type = types.nullOr regex;
                  default = null;
                };
                title = mkOption {
                  type = types.nullOr regex;
                  default = null;
                };
                initialClass = mkOption {
                  type = types.nullOr regex;
                  default = null;
                };
                initialTitle = mkOption {
                  type = types.nullOr regex;
                  default = null;
                };
                tag = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                xWayland = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                float = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                fullscreen = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                pin = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                focus = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                group = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                modal = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                fullscreenStateClient = mkOption {
                  type = types.nullOr fullscreenState;
                  default = null;
                };
                fullscreenStateInternal = mkOption {
                  type = types.nullOr fullscreenState;
                  default = null;
                };
                content = mkOption {
                  type = types.nullOr content;
                  default = null;
                };
                xdgTag = mkOption {
                  type = types.nullOr regex;
                  default = null;
                };
              };
              properties = {
                float = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                tile = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                fullscreen = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                maximize = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                center = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                pseudoTile = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                monitor = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                initialFocus = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                pin = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                persistentSize = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                immediate = mkOption {
                  type = types.nullOr types.bool;
                  default = null;
                };
                content = mkOption {
                  type = types.nullOr content;
                  default = null;
                };
                scrollFactor = {
                  touchpad = mkOption {
                    type = types.nullOr types.float;
                    default = null;
                  };
                  mouse = mkOption {
                    type = types.nullOr types.float;
                    default = null;
                  };
                };
                idleInhibit = mkOption {
                  type = types.nullOr (
                    types.enum [
                      "none"
                      "always"
                      "focus"
                      "fullscreen"
                    ]
                  );
                  default = null;
                };
                scalingMode = mkOption {
                  type = types.nullOr (
                    types.enum [
                      "nearestNeighbor"
                    ]
                  );
                  default = null;
                };
                fullscreenState = mkOption {
                  type = types.nullOr (
                    types.submoduleWith {
                      modules = [
                        (
                          { lib, ... }:
                          {
                            options = {
                              internal = lib.mkOption {
                                type = fullscreenState;
                              };
                              client = lib.mkOption {
                                type = fullscreenState;
                              };
                            };
                          }
                        )
                      ];
                    }
                  );
                  default = null;
                };
                move = mkOption {
                  type = types.nullOr (
                    types.submoduleWith {
                      modules = [
                        (
                          { lib, ... }:
                          {
                            options = {
                              x = lib.mkOption {
                                type = lib.types.str;
                              };
                              y = lib.mkOption {
                                type = lib.types.str;
                              };
                            };
                          }
                        )
                      ];
                    }
                  );
                  default = null;
                };
                size = mkOption {
                  type = types.nullOr (
                    types.submoduleWith {
                      modules = [
                        (
                          { lib, ... }:
                          {
                            options = {
                              width = lib.mkOption {
                                type = lib.types.str;
                              };
                              height = lib.mkOption {
                                type = lib.types.str;
                              };
                            };
                          }
                        )
                      ];
                    }
                  );
                  default = null;
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
        type = types.listOf window;
        default = [ ];
      };
    };
  disabledModules = [ ];
  imports = [ ];
  config = {
    desktop.windows = [
      {
        name = "nearest_neighbor";
        criteria = {
          appId = ".*";
        };
        properties = {
          scalingMode = "nearestNeighbor";
        };
      }
      {
        name = "fullscreen_inhibits_idle";
        criteria = {
          fullscreen = true;
        };
        properties = {
          idleInhibit = "fullscreen";
        };
      }
      {
        name = "float_modals";
        criteria = {
          modal = true;
        };
        properties = {
          float = true;
        };
      }
      # {
      #   criteria = {
      #     appId = "xdg-desktop-portal-gtk";
      #     title = "Open Files";
      #   };
      #   properties = {
      #     float = true;
      #   };
      # }
    ];
  };
  meta = { };
}
