{
  config,
  pkgs,
  ...
}:
{
  config = {
    # home.packages = [
    #   # ghc
    #   # stack
    #   # cabal-install
    #   pkgs.haskell-language-server
    #   pkgs.ormolu
    # ];
    home.sessionPath = [ "${config.home.homeDirectory}/.cabal/bin" ];
  };
}
