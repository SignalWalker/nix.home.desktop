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
    home.packages = with pkgs; [
      mold
    ];
    signal.dev.lang.c.linker = "mold";
    # dev.lang.rust.cargo.linker = "mold";
  };
}
