{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
in
{
  options = with lib; { };
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

    programs.wrtag.enable = true;

    home.packages = [
      (pkgs.renoise.override {
        releasePath = pkgs.requireFile {
          name = "rns_352_linux_x86_64.tar.gz";
          url = "https://backstage.renoise.com/frontend/app/index.html#/product/rns";
          hash = "sha256-iXqCgOLxIvPrSSOpZbK8Aa/Ve5CK0oBK4bLsFDiY+oo=";
        };
      })
    ]
    ++ [
    ]
    # plugins
    ++ [
      pkgs.sfizz
      pkgs.redux
      pkgs.CHOWTapeModel
      pkgs.artyFX
      # pkgs.fmsynth
      pkgs.infamousPlugins
      pkgs.rnnoise-plugin
    ]
    ++ (with pkgs; [
      # lmms # build failure 2025-01-07
      # sunvox # build failure 2025-09-03
      furnace
      # ardour
      reaper

      supercollider-with-plugins

      # nicotine-plus # removed due to collision with httm
    ]);
  };
  meta = { };
}
