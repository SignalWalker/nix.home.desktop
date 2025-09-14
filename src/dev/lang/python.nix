{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  uv = config.programs.uv;
in
{
  options = { };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkMerge [
    {
      home.packages = [
        pkgs.python3
      ];
      programs.uv = {
        enable = true;
        settings = { };
      };
    }
    (lib.mkIf uv.enable {
      systemd.user.sessionVariables = {
        "UV_TOOL_BIN_DIR" = "${config.xdg.dataHome}/uv/bin";
      };
      home.sessionPath = [ config.systemd.user.sessionVariables.UV_TOOL_BIN_DIR ];
    })
  ];
  meta = { };
}
