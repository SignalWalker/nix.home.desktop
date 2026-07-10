{
  config,
  pkgs,
  ...
}:
{
  config = {
    home.sessionPath = [ "${config.home.homeDirectory}/.cabal/bin" ];
  };
}
