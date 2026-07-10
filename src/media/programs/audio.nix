{
  pkgs,
  lib,
  ...
}:
{
  options = { };
  disabledModules = [ ];
  imports = lib.listFilePaths ./audio;
  config = {
    programs.yt-dlp = {
      enable = true;
      settings = {
        "cookies-from-browser" = "firefox+gnomekeyring";
        "audio-quality" = 0;
        "embed-thumbnail" = true;
        "embed-metadata" = true;
        "embed-subs" = true;
        "write-link" = true;
        "write-description" = true;
        "abort-on-error" = true;
      };
    };

    programs.wrtag = {
      enable = true;
    };

    home.packages =
      # plugins
      [
        pkgs.sfizz
        pkgs.redux
        # pkgs.CHOWTapeModel # build failure 2025-10-20
        # pkgs.artyFX # build failure 2025-10-20
        # pkgs.infamousPlugins # build failure 2025-10-20
        # pkgs.fmsynth
        pkgs.rnnoise-plugin

      ];
  };
  meta = { };
}
