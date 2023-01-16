{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  music = config.xdg.userDirs.music;
in {
  imports = lib.signal.fs.path.listFilePaths ./player;
  config = {
    home.packages = with pkgs; [
      (cantata.override {
        withCdda = true;
        withCddb = true;
        withTaglib = true;
        withMusicbrainz = true;
      })
    ];
    programs.quodlibet = {
      enable = config.system.isNixOS or true;
      package = pkgs.quodlibet-full;
    };
    programs.ncmpcpp = {
      enable = false;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
      mpdMusicDir = "${music}/library";
      settings = {
        ncmpcpp_directory = "${config.xdg.dataHome}/ncmpcpp";
        lyrics_directory = "${config.xdg.cacheHome}/lyrics";
      };
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
