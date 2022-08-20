{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.terminal;
in {
  options.signal.desktop.terminal = with lib; {
    app = mkOption {
      type = types.enum [ "kitty" ];
      default = "kitty";
    };
    command = mkOption {
      type = types.str;
      default = cfg.app;
    };
  };
  imports = lib.signal.fs.listFiles ./terminal;
  config = {

  };
}
