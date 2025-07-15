{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.lang.haskell;
in {
  options.signal.dev.lang.haskell = with lib; {
    enable = (mkEnableOption "Haskell language") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      # ghc
      # stack
      # cabal-install
      haskell-language-server
      ormolu
    ];
    home.sessionPath = ["${config.home.homeDirectory}/.cabal/bin"];
  };
}
