{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.lang.zig;
in {
  options.dev.lang.zig = with lib; {
    enable = mkEnableOption "Zig language";
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = with pkgs; [
      zig
      zls
    ];
  };
}
