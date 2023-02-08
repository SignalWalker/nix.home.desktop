{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  beetcfg = config.programs.beets.settings;
in {
  options = with lib; {};
  imports = [];
  config = let
    music = config.xdg.userDirs.music;
  in {
    programs.beets = {
      enable = true;
      package = pkgs.beetsPackages.beets-unstable.overrideAttrs (final: prev: {
        src = config.signal.media.flakeInputs.beetsSrc;
        patches = [];
        version = "git";
      });
      settings = {
        color = true;
        directory = "${music}/library";
        library = "${music}/.beets/library.db";
        ignore_hidden = true;
        per_disc_numbering = true;
        import = {
          copy = false;
          move = true;
          incremental_skip_later = true;
          group_albums = true;
          bell = true;
          detail = true;
        };
        match = {
          strong_rec_thresh = 0.06;
          max_rec.missing_tracks = "strong";
          preferred = {
            countries = ["XW" "US"];
            media = ["Digital Media|File" "CD"];
            original_year = true;
          };
          ignored = ["length"];
        };
        paths = {
          default = "$albumartist/$album%aunique{}/$disc-$\{track\}.$title";
          singleton = "$artist/$title";
          comp = "multiple/$album%aunique{}/$disc-$\{track\}.$title";
        };
        plugins = [
          "missing"
          "importadded"
          "chroma"
          "discogs"
          "spotify"
          "fromfilename"
          "lastimport"
          "lastgenre"
          "scrub"
          "fetchart"
          "acousticbrainz"
          "mbsync"
          "thumbnails"
          "replaygain"
          "permissions"
          "duplicates"
          "convert"
        ];
        musicbrainz = {
          auto = true;
          genres = true;
          remove = true;
          user = "SignalWalker";
        };
        discogs = {
          index_tracks = true;
        };
        lyrics = {
          auto = true;
          sources = ["musixmatch" "genius"];
        };
        chroma = {
          auto = true;
          source_weight = 0.0;
        };
        lastfm = {
          user = "SignalWalker";
        };
        bandcamp.art = true;
        thumbnails.auto = true;
        replaygain.backend = "ffmpeg";
        mpd = {
          host = config.services.mpd.network.listenAddress;
          port = config.services.mpd.network.port;
        };
        convert = {
          auto = false;
          delete_originals = false;
          never_convert_lossy_files = true;
          max_bitrate = "none";
          link = false;
          hardlink = false;
          format = "opus";
          formats = {
            opus = {
              command = "opusenc --music \"$source\" \"$dest\"";
              extension = "ogg";
            };
          };
        };
      };
    };
  };
}
