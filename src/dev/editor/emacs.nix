{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  ed = config.signal.dev.editor;
  emacs = config.programs.neovim;
in {
  options = with lib; {};
  imports = [];
  config = lib.mkIf ed.enable {
    programs.emacs = {
      enable = true;
    };
  };
}
