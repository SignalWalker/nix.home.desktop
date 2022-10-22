{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.editor;
in {
  options.signal.desktop.editor = with lib; {
    enable = (mkEnableOption "text editor GUI") // {default = config.signal.dev.editor.enable or false;};
  };
  imports = lib.signal.fs.path.listFilePaths ./editor;
  config = lib.mkIf cfg.enable {};
}
