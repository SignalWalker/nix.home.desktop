{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.desktop.keyboard = with lib; {
    compositor = {
      modifier = mkOption {
        type = types.enum ["Mod1" "Mod2" "Mod3" "Mod4" "Mod5"];
        default = "Mod3";
      };
    };
  };
  imports = [];
  config = {
    home.file.".xkb/symbols/hypersuper".text = ''
      partial modifier_keys xkb_symbols "mods" {
        modifier_map Mod3 { Super_L, Super_R };
        key <SUPR> { [ NoSymbol, Super_L ] };
        modifier_map Mod3 { <SUPR> };

        modifier_map Mod4 { Hyper_L, Hyper_R };
        key <HYPR> { [ NoSymbol, Hyper_L ] };
        modifier_map Mod4 { <HYPR> };
      };
      default xkb_symbols "us" {
        include "us"
        include "hypersuper(mods)"
      };
    '';
  };
}
