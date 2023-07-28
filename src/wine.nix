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
    home.packages = [pkgs.bottles];
    xdg.binFile."wine" = {
      executable = true;
      text = ''
        #! /usr/bin/env sh
        bottles-cli run -b Standard -e "$@"
      '';
    };
  };
  meta = {};
}
