{
  config,
  pkgs,
  ...
}:
with builtins; {
  config = {
    xdg.mime.enable = true;
    xdg.mimeApps = let
      std = pkgs.lib;
      mapDesktop = map (e: e + ".desktop");
      genMimes = types: entries: std.genAttrs types (type: entries);
      mapSets = std.foldl (acc: {
        types,
        entries,
      }:
        acc // (genMimes types (mapDesktop entries))) {
        types = [];
        entries = [];
      };
    in {
      enable = true;
      defaultApplications = mapSets [
        {
          types = [
            "text/html"
            "x-scheme-handler/chrome"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];
          entries = ["firefox-nightly" "firefox"];
        }
        {
          types = ["x-scheme-handler/mailto"];
          entries = ["thunderbird-nightly" "thunderbird"];
        }
        {
          types = ["text/plain"];
          entries = ["neovide-multigrid" "neovide"];
        }
        {
          types = ["inode/directory"];
          entries = ["org.kde.dolphin"];
        }
      ];
    };
  };
}
