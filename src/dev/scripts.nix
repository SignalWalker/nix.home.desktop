{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
{
  options = with lib; { };
  imports = [ ];
  config = {
    xdg.binFile = lib.genAttrs (lib.listFilePaths ./scripts) (script: {
      target = baseNameOf script;
      executable = true;
      source = script;
    });
  };
}
