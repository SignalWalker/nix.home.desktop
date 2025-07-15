{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
{
  options = with lib; {
  };
  imports = [ ];
  config = {
    programs.ashvim = {
      enable = true;
      configPath = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/cfg/neovim";
    };
  };
}
