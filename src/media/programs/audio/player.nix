{ config
, pkgs
, lib
, ...
}:
with builtins; let
in
{
  config = {
    # programs.quodlibet = {
    #   enable = false;
    #   package = pkgs.quodlibet-full;
    # };
    programs.ncmpcpp = {
      enable = false; # config.services.mpd.enable;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    };
    signal.desktop.wayland.compositor.scratchpads = [
      { kb = "Shift+W"; criteria = { app_id = "cantata"; }; resize = 50; startup = "cantata"; }
    ];
  };
}
