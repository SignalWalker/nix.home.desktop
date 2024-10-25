{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;

  window = lib.types.submoduleWith {
    modules = [
      ({
        config,
        lib,
        pkgs,
        ...
      }: {
        options = with lib; {
          criteria = mkOption {
            type = types.addCheck (types.either types.bool (types.attrsOf (types.oneOf [types.int types.bool types.str]))) (v: v != false);
            description = "Either the criteria used to identify the window, or `true` to indicate that this should apply to all windows.";
          };
          floating = mkEnableOption "open window as floating when applicable";
          inhibit_idle = mkOption {
            type = types.nullOr (types.enum ["focus" "fullscreen" "open" "none" "visible"]);
            default = null;
          };
        };
      })
    ];
  };
in {
  options = with lib; {
    desktop.windows = mkOption {
      type = types.listOf window;
      default = [];
    };
  };
  disabledModules = [];
  imports = [];
  config = {
    desktop.windows = [
      {
        criteria = true;
        inhibit_idle = "fullscreen";
      }
      {
        criteria = {
          app_id = "xdg-desktop-portal-gtk";
          title = "Open Files";
        };
        floating = true;
      }
    ];
  };
  meta = {};
}
