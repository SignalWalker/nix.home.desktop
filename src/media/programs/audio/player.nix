{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
in {
  config = {
    programs.quodlibet = {
      enable = true;
      package = pkgs.quodlibet-full;
    };
    programs.ncmpcpp = {
      enable = false; # config.services.mpd.enable;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
    };
    signal.desktop.scratch.scratchpads = {
      "Shift+W" = {
        criteria = {app_id = "io.github.quodlibet.QuodLibet";};
        resize = 75;
        startup = "quodlibet";
      };
    };
  };
}
