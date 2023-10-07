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
      enable = true; # disabled because it's not building rn (2022-07-05)
      package = pkgs.beetsPackages.beets-unstable;
      # .overrideAttrs (final: prev: {
      #   src = config.signal.media.flakeInputs.beetsSrc;
      #   patches = [];
      #   version = "git";
      #   propagatedBuildInputs = prev.propagatedBuildInputs ++ (with pkgs.python3Packages; [typing-extensions]);
      # });
      settings = {
        color = true;
        directory = "${music}/library";
        library = "${music}/.beets/library.db";
        ignore_hidden = true;
        per_disc_numbering = true;
        import = {
          copy = true;
          move = false;
          write = true;
          hardlink = false;
          reflink = false;
          incremental_skip_later = true;
          group_albums = false;
          bell = true;
          detail = true;
          from_scratch = true;
        };
        match = {
          strong_rec_thresh = 0.10;
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
          # sources
          # "discogs"
          # "spotify"
          "chroma"
          "fromfilename"
          # "lastgenre"
          # other
          "missing"
          "importadded"
          "lastimport"
          "scrub"
          "fetchart"
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
          extra_tags = ["year"];
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
          max_bitrate = 999999; # can't set "none" from nix, i think
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
