{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.editor;
  hlx = cfg.helix;
  ed = config.signal.dev.editor.editors."helix";
in {
  options.signal.desktop.editor.helix = with lib; {
    enable = (mkEnableOption "helix GUI") // {default = config.signal.dev.editor.helix.enable or false;};
    src = mkOption {type = types.path;};
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf (cfg.enable && hlx.enable) {
    xdg.dataFile."applications/Helix.desktop" = {
      source = "${hlx.src}/contrib/Helix.desktop";
    };
  };
  meta = {};
}
