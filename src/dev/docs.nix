{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.docs;
in {
  options.signal.dev.docs = with lib; {
    enable = mkEnableOption "Zeal documentation browser";
    package = mkOption {
      type = types.package;
      default = pkgs.zeal;
    };
    docsets = mkOption {
      type = types.listOf types.package;
      default = [];
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    home.packages = [cfg.package];
  };
}
