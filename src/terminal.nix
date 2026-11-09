{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.desktop.terminal;
in {
  options.desktop.terminal = {
    app = lib.mkOption {
      type = lib.types.enum ["kitty" "alacritty"];
      default = "kitty";
    };
    command = lib.mkOption {
      type = lib.types.str;
      default = cfg.app;
    };
  };
  imports = lib.listFilePaths ./terminal;
  config = {
  };
}
