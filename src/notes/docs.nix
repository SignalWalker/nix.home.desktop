{
  config,
  pkgs,
  lib,
  ...
}:
let
  docs = config.signal.desktop.notes.docs;
in
{
  options =
    let
      inherit (lib) mkEnableOption mkOption types;
    in
    {
      signal.desktop.notes.docs = {
        enable = (mkEnableOption "Zeal documentation browser") // {
          default = false;
        };
        package = mkOption {
          type = types.package;
          default = pkgs.zeal;
        };
        docsets = mkOption {
          type = types.listOf types.package;
          default = [ ];
        };
      };
    };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf docs.enable {
    home.packages = [ docs.package ];
    desktop.scratchpads = {
      "Shift+X" = {
        criteria = {
          app_id = "org.zealdocs.zeal";
          title = "^.* - Zeal";
        };
        resize = 93;
        startup = "zeal";
        systemdCat = true;
        automove = true;
        autostart = false;
      };
    };
  };
  meta = { };
}

