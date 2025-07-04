{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  mkSearch = keyword: url: {
    inherit keyword url;
  };
in
{
  options = with lib; { };
  imports = lib.signal.fs.path.listFilePaths ./browser;
  config = {
    programs.qutebrowser = {
      enable = false;
    };
  };
}
