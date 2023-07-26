{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  lua = config.signal.dev.lang.lua;
in {
  options = with lib; {
    signal.dev.lang.lua = {
      enable = (mkEnableOption "lua language support") // {default = true;};
      languageServer = mkOption {
        type = types.package;
        default = pkgs.sumneko-lua-language-server;
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf lua.enable {
    home.packages = [lua.languageServer];
  };
  meta = {};
}
