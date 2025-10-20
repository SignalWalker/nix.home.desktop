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

    home.packages = [
      (pkgs.renoise.override {
        releasePath = pkgs.requireFile {
          name = "rns_352_linux_x86_64.tar.gz";
          url = "https://backstage.renoise.com/frontend/app/index.html#/product/rns";
          hash = "sha256-iXqCgOLxIvPrSSOpZbK8Aa/Ve5CK0oBK4bLsFDiY+oo=";
        };
      })
      pkgs.furnace
      pkgs.reaper
      pkgs.supercollider-with-plugins
      # lmms # build failure 2025-01-07
      # sunvox # build failure 2025-09-03
      # ardour
      # nicotine-plus # removed due to collision with httm
    ]
    # plugins
    ++ [
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
