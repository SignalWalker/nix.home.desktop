{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.linker;
in {
  options.dev.linker = with lib; {
    enable = mkEnableOption "linker configuration";
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = with pkgs; [
      mold
    ];
    dev.lang.c.linker = "mold";
    # dev.lang.rust.cargo.linker = "mold";
  };
}
