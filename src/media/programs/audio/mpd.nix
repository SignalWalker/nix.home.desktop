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
  imports = [];
  config = let
    music = config.xdg.userDirs.music;
  in {
    services.mpd = {
      enable = false;
      dataDir = "${config.xdg.dataHome}/mpd";
      musicDirectory = "${music}/library";
      playlistDirectory = "${music}/playlists";
      network.startWhenNeeded = true;
      network.listenAddress = "127.0.0.1";
      network.port = 6600;
      extraConfig = ''
        zeroconf_enabled "yes"
        zeroconf_name "MPD @ %h"

        restore_paused "yes"
        auto_update "yes"
        audio_output {
          type "pipewire"
          name "pipewire audio"
        }
      '';
    };
    services.mpdris2 = {
      enable = config.services.mpd.enable;
      notifications = true;
      multimediaKeys = false;
    };
  };
}
