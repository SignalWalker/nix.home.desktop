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
  disabledModules = [];
  imports = lib.signal.fs.path.listFilePaths ./audio;
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

    home.packages = with pkgs; [
      lmms
      sunvox
      renoise
      # ardour
      reaper

      nicotine-plus
    ];
  };
  meta = {};
}
