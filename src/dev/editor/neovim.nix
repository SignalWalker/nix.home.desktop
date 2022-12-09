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
    programs.neovim = {
      enable = true;
      package =
        if (config.system.isNixOS or true)
        then pkgs.neovim
        else (lib.signal.home.linkSystemApp pkgs {app = "nvim";});
    };
  };
}
