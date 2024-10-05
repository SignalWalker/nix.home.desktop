{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.desktop.browser.firefox = with lib; {};
  disabledModules = [];
  imports = [];
  config = let
    firefoxCmd = "firefox-nightly";
  in {
    desktop.scratchpads = {
      "Shift+F" = {
        criteria = {app_id = "^firefox*";};
        resize = 93;
        startup = firefoxCmd;
        name = "firefox";
        systemdCat = true;
      };
    };
    desktop.windows = [
      {
        criteria = {
          app_id = "^firefox*";
          title = "Extension: .*";
        };
        floating = true;
      }
    ];
    systemd.user.sessionVariables = {
      BROWSER = firefoxCmd;
      MOZ_DBUS_REMOTE = 1;
    };
    programs.firefox = let
      searchMarks =
        std.mapAttrs'
        (name: settings:
          std.nameValuePair "Search ${name}" (settings
            // {
              keyword = "!${settings.keyword}";
            }))
        {
          "Wikipedia" = {
            keyword = "wiki";
            url = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&language=en&search=%s&language=en&go=Go";
          };
          "Arch Wiki" = {
            keyword = "arch";
            url = "https://wiki.archlinux.org/index.php?search=%s";
          };
          "AUR" = {
            keyword = "aur";
            url = "https://aur.archlinux.org/packages?K=%s";
          };
          "YouTube" = {
            keyword = "yt";
            url = "https://www.youtube.com/results?search_query=%s";
          };
          "Ao3" = {
            keyword = "ao3";
            url = "javascript:window.location.href=\"https://archiveofourown.org/works/search?utf8=✓&work_search[query]=%s\"";
          };
          "Rust Standard Library" = {
            keyword = "ruststd";
            url = "https://doc.rust-lang.org/nightly/std/index.html?search=%s";
          };
          "GitHub" = {
            keyword = "gh";
            url = "https://github.com/search?q=%s";
          };
          "Nix Wiki" = {
            keyword = "nix";
            url = "https://nixos.wiki/index.php?search=%s";
          };
          "Nix Manual" = {
            keyword = "nixman";
            url = "https://nixos.org/manual/nix/unstable/?search=%s";
          };
          "NixOS Options" = {
            keyword = "nixopt";
            url = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=alpha_asc&query=%s";
          };
          "Nix Packages" = {
            keyword = "nixpkg";
            url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=alpha_asc&query=%s";
          };
          "Nix Flakes" = {
            keyword = "nixflk";
            url = "https://search.nixos.org/flakes?channel=unstable&=%s";
          };
          "Nix Hound" = {
            keyword = "nixhn";
            url = "javascript:window.location.href=\"https://search.nix.gsc.io/?q=%s\"";
          };
        };
      gotoMarks = std.mapAttrs' (name: settings: std.nameValuePair "GOTO ${name}" (settings // {keyword = "@${settings.keyword}";})) {
        "GitHub" = {
          keyword = "gh";
          url = "javascript:window.location.href=\"https://github.com/%s\"";
        };
      };
      common = {
        bookmarks =
          searchMarks
          // gotoMarks
          // {
            "Nix Manual" = {
              url = "https://nixos.org/manual/nix/unstable";
            };
            "Nixpkgs Manual" = {
              url = "https://nixos.org/manual/nixpkgs/unstable";
            };
            "NixOS Manual" = {
              url = "https://nixos.org/manual/nixos/unstable";
            };
          };
      };
    in {
      enable = config.system.isNixOS;
      # package = pkgs.latest.firefox-nightly-bin;
      # package = pkgs.firefox-beta-bin;
      profiles =
        (std.mapAttrs (profile: settings: std.recursiveUpdate (removeAttrs common ["bookmarks"]) settings) {
          main = {
            id = 0;
            name = "main";
            isDefault = true;
          };
        })
        // (std.mapAttrs (profile: settings: std.recursiveUpdate common settings) {
          media = {
            id = 1;
            name = "media";
            isDefault = false;
          };
        });
    };
  };
  meta = {};
}
