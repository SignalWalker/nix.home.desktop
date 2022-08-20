{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.lang.zig;
in {
  options.signal.dev.lang.zig = with lib; {
    enable = (mkEnableOption "Zig language") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      zig
      zls
    ];
  };
}
