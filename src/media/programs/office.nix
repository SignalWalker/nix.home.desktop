{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    # home.packages = with pkgs; [
    #   libreoffice-qt
    #   hunspell
    #   hunspellDicts.en_US
    # ];
  };
  meta = {};
}
