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
            type = types.attrsOf (types.oneOf [types.int types.bool types.str]);
            description = "The criteria used to identify the window.";
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
        criteria = {};
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
