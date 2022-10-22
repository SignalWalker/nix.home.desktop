{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.editor;
  editor = lib.types.submoduleWith {
    modules = [
      ({
        config,
        lib,
        ...
      }: {
        options = with lib; {
          cmd = {
            term = mkOption {type = types.str;};
            visual = mkOption {
              type = types.nullOr types.str;
              default = config.cmd.term;
            };
            gui = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        };
        imports = [];
        config = {};
      })
    ];
  };
in {
  options.signal.dev.editor = with lib; {
    enable = (mkEnableOption "text editor") // {default = true;};
    editors = mkOption {
      type = types.attrsOf editor;
      default = {};
    };
    default = mkOption {
      type = editor;
      default = cfg.editors."neovim";
    };
  };
  disabledModules = [];
  imports = lib.signal.fs.path.listFilePaths ./editor;
  config = lib.mkIf cfg.enable {
    lib.signal.dev.types.editor = editor;
    systemd.user.sessionVariables = lib.mkMerge [
      {EDITOR = cfg.default.cmd.term;}
      (lib.mkIf (cfg.default.cmd.visual != null) {VISUAL = cfg.default.cmd.visual;})
    ];
  };
  meta = {};
}
