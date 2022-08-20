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
    programs.beets = {
      enable = true;
      package = pkgs.beetsPackages.beets-unstable;
      settings = {
        color = true;
        directory = "${music}/library";
        library = "${music}/.beets/library.db";
        ignore_hidden = true;
        per_disc_numbering = true;
        import = {
          copy = false;
          move = true;
          incremental = true;
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
            media = ["Digital Media|File" "CD" "Vinyl"];
            original_year = true;
          };
        };
        paths = {
          default = "$albumartist/$album%aunique{}/$disc-$\{track\}.$title";
          singleton = "$artist/$title";
          comp = "multiple/$album%aunique{}/$disc-$\{track\}.$title";
        };
        replace = {
          "[\\/]" = "-";
          "^\\." = "_";
          "[\\x00-\\x1f]" = "_";
          "\\.$" = "_";
          "\\s+$" = "";
          "^\\s+" = "";
        };
        musicbrainz.genre = true;
        plugins = [
          "missing"
          "importadded"
          "chroma"
          "discogs"
          "spotify"
          "fromfilename"
          "mbsync"
          "lastimport"
          "scrub"
          "fetchart"
        ];
        lyrics.auto = false;
        chroma = {
          auto = true;
          source_weight = 0.0;
        };
        lastfm.user = "SignalWalker";
        bandcamp.art = true;
      };
    };
  };
}
