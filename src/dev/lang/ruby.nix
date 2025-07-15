{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    home.sessionPath = ["${config.xdg.dataHome}/gem/ruby/3.0.0/bin"];
  };
  meta = {};
}
