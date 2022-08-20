{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
in {
  config = {
    # programs.quodlibet = {
    #   enable = false;
    #   package = pkgs.quodlibet-full;
    # };
    programs.ncmpcpp = {
      enable = false; # config.services.mpd.enable;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
    };
  };
}
