{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  ed = config.signal.dev.editor;
  nvim = config.programs.neovim;
in {
  options = with lib; {};
  imports = [];
  config = lib.mkIf ed.enable {
    programs.ashvim = {
      enable = true;
      configPath = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/cfg/neovim";
    };
  };
}
