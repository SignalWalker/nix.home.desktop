{
  config,
  ...
}:
{
  options = {
  };
  imports = [ ];
  config = {
    programs.ashvim = {
      enable = true;
      configPath = "${config.xdg.userDirs.extraConfig.PROJECTS}/cfg/neovim";
    };
  };
}
