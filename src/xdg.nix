{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
  };
  disabledModules = [ ];
  imports = [ ];
  config =
    let
      xdg = config.xdg;
    in
    {
      xdg = {
        mime.enable = true;
        portal = {
          enable = false;
        };
        autostart = {
          enable = true;
          readOnly = true;
        };
      };
      # old applications might expect mimeapps.list to be in ~/.local/share/applications, so we'll link it to the new one
      home.activation."symlink-old-mimeapps-to-new" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir $VERBOSE_ARG -p "${xdg.dataHome}/applications"
        run ln $VERBOSE_ARG -sfT "${xdg.configHome}/mimeapps.list" "${xdg.dataHome}/applications/mimeapps.list"
      '';
    };
  meta = { };
}
