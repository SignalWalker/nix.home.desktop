{
  config,
  pkgs,
  lib,
  ...
}:
let
  musicDir = config.xdg.userDirs.music;
  mpd = config.services.mpd;
in
{
  config = {
    home.packages = lib.mkIf config.services.mopidy.enable [ pkgs.mopidy ];
    services.mopidy = {
      enable = false;
      extensionPackages = [
        pkgs.mopidy-bandcamp
        pkgs.mopidy-jellyfin
        pkgs.mopidy-local
        pkgs.mopidy-mpd
        pkgs.mopidy-mpris
        pkgs.mopidy-soundcloud
        pkgs.mopidy-youtube
        pkgs.mopidy-iris
        pkgs.mopidy-muse
      ];
      settings = {
        file = {
          media_dirs = [ "${musicDir}/library" ];
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
  meta = { };
}
