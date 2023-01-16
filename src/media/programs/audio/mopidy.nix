{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  musicDir = config.xdg.userDirs.music;
  mpd = config.services.mpd;
  mopidy = config.services.mopidy.settings;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    home.packages = lib.mkIf config.services.mopidy.enable [pkgs.mopidy];
    services.mopidy = {
      enable = false;
      extensionPackages = with pkgs; [
        mopidy-bandcamp
        mopidy-jellyfin
        mopidy-local
        mopidy-mpd
        mopidy-mpris
        mopidy-soundcloud
        mopidy-youtube
        mopidy-iris
        mopidy-muse
      ];
      settings = {
        file = {
          media_dirs = ["${musicDir}/library"];
          follow_symlinks = true;
        };
        local = {
          media_dir = "${musicDir}/library";
          scan_follow_symlinks = true;
          use_artist_sortname = true;
        };
        mpd = {
          hostname = mpd.network.listenAddress;
          port = mpd.network.port;
        };
        m3u = {
          base_dir = "${musicDir}/library";
          playlists_dir = "${musicDir}/playlists";
        };
        http = {
          enabled = true;
          hostname = "::1";
          port = 6680;
          zeroconf = "Mopidy HTTP server on $hostname";
        };
        iris = {
          country = "us";
          locale = "en_US";
        };
      };
    };
  };
  meta = {};
}
