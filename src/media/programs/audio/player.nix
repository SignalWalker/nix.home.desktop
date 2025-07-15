{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  music = config.xdg.userDirs.music;
  mpd = config.services.mpd;
in
{
  imports = lib.signal.fs.path.listFilePaths ./player;
  config = {
    home.packages = lib.mkMerge [
      (lib.mkIf mpd.enable [
        (pkgs.cantata.override {
          withCdda = true;
          withCddb = true;
          withTaglib = true;
          withMusicbrainz = true;
        })
      ])
    ];
    programs.quodlibet = {
      enable = false; # config.system.isNixOS or true;
    };
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
          app_id = "io.github.quodlibet.QuodLibet";
          title = "^(.* - )?Quod Libet";
        };
        resize = 75;
        startup = "quodlibet";
        systemdCat = true;
        automove = true;
      };
    };
  };
}
