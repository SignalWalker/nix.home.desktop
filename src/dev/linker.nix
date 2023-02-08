{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.linker;
in {
  options.signal.dev.linker = with lib; {
    enable = (mkEnableOption "linker configuration") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    home.packages = lib.mkIf (config.system.isNixOS or true) (with pkgs; [mold]);
    signal.dev.lang.c.linker = "mold";
    signal.dev.lang.rust.cargo.linker = "mold";
  };
}
