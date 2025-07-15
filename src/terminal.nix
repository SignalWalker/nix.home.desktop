{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.desktop.terminal;
in {
  options.desktop.terminal = with lib; {
    app = mkOption {
      type = types.enum ["kitty"];
      default = "kitty";
    };
    command = mkOption {
      type = types.str;
      default = cfg.app;
    };
  };
  imports = lib.listFilePaths ./terminal;
  config = {
  };
}