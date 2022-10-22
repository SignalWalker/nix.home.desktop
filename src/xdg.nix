{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  cfg = config.signal.desktop.xdg;
  xdgEntry = lib.types.submoduleWith {
    modules = [
      ({
        config,
        lib,
        ...
      }: {
        options = with lib; {
          definition = mkOption {
            type = types.nullOr (types.attrsOf types.anything);
            default = null;
          };
          defaultFor = mkOption {
            type = types.listOf types.str;
            default = [];
          };
        };
        config = {};
      })
    ];
  };
in {
  options.signal.desktop.xdg = with lib; {
    enable = (mkEnableOption "XDG config") // {default = true;};
    applications = mkOption {
      type = types.attrsOf xdgEntry;
      default = {};
    };
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    xdg.mime.enable = true;
    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications =
      foldl'
      (acc: name: let
        app = cfg.applications.${name};
      in
        foldl'
        (res: mime:
          res // {${mime} = (res.${mime} or []) ++ ["${name}.desktop"];})
        acc
        app.defaultFor)
      {}
      (attrNames cfg.applications);
    xdg.desktopEntries =
      foldl'
      (acc: name: let
        app = cfg.applications.${name};
      in
        if app.definition != null
        then
          acc
          // {
            ${name} = app.definition;
          }
        else acc)
      {}
      (attrNames cfg.applications);
  };
}
