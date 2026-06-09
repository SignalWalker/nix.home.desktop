{
  config,
  lib,
  ...
}:
let
  cfg = config.signal.desktop.editor;
in
{
  options.signal.desktop.editor = {
    enable = (lib.mkEnableOption "text editor GUI") // {
      default = config.signal.dev.editor.enable or false;
    };
  };
  imports = lib.listFilePaths ./editor;
  config = lib.mkIf cfg.enable { };
}

