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
  imports = [];
  config = let
    scripts = lib.signal.fs.listFiles' ./scripts;
  in {
    xdg.binFile = std.genAttrs scripts (script: {
      executable = true;
      source = ./scripts/${script};
    });
  };
}
