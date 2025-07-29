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
  config =
    let
      scripts = listToAttrs (
        map (
          script:
          let
            name = baseNameOf script;
          in
          {
            name = unsafeDiscardStringContext name;
            value = script;
          }
        ) (lib.listFilePaths ./scripts)
      );
    in
    {
      xdg.binFile = mapAttrs (name: source: {
        executable = true;
        inherit source;
      }) scripts;
    };
}
