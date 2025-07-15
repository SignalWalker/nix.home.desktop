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
    home.packages = [
      (pkgs.openjdk.override {
        enableJavaFX = true;
      })
    ];
  };
  meta = {};
}
