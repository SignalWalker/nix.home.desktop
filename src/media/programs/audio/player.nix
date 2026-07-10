{
  config,
  pkgs,
  lib,
  ...
}:
let
  music = config.xdg.userDirs.music;
  mpd = config.services.mpd;
in
{
  config = {
    programs.ncmpcpp = {
      enable = mpd.enable;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
      mpdMusicDir = "${music}/library";
      settings = {
        ncmpcpp_directory = "${config.xdg.dataHome}/ncmpcpp";
        lyrics_directory = "${config.xdg.cacheHome}/lyrics";
      };
    };
    desktop.scratchpads = {
      "Shift+W" = {
        criteria = {
          # app_id = "io.github.quodlibet.QuodLibet";
          # title = "^(.* - )?Quod Libet";
          # app_id = "tauonmb";
          # app_id = "Psysonic";
          app_id = "org.fooyin.fooyin";
        };
        resize = 75;
        startup = "fooyin";
        systemdCat = true;
        automove = true;
      };
    };
  };
}
