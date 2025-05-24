{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  cfg = config.signal.desktop.editor;
  nvm = cfg.neovim;
in
{
  options.signal.desktop.editor.neovim = with lib; {
    enable = (mkEnableOption "neovim GUI") // {
      default = config.signal.dev.editor.editors.neovim.enable or false;
    };
    package = mkOption {
      type = types.package;
      default =
        if config.system.isNixOS then
          pkgs.neovide
        else
          lib.signal.home.linkSystemApp pkgs { app = "neovide"; };
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf (cfg.enable && nvm.enable) (
    lib.mkMerge [
      {
        home.packages = [ nvm.package ];
      }
    ]
  );
  meta = { };
}
