{
  config,
  pkgs,
  lib,
  ...
}:
let
  dolphin = config.signal.desktop.explorer.dolphin;
  nemo = config.signal.desktop.explorer.nemo;
  yazi = config.programs.yazi;
in
{
  options = {
    signal.desktop.explorer = {
      dolphin = {
        enable = (lib.mkEnableOption "dolphin file explorer") // {
          default = false;
        };
      };
      nemo = {
        enable = (lib.mkEnableOption "nemo file explorer") // {
          default = !dolphin.enable;
        };
      };
      thunar = {
        enable = (lib.mkEnableOption "thunar file explorer") // {
          default = (!dolphin.enable) && (!nemo.enable);
        };
      };
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkMerge [
    {
      home.packages = [
        # TODO :: why
        pkgs.kdePackages.kdialog
      ];
    }
    (lib.mkIf yazi.enable {
      programs.app2unit.enable = true;
      home.packages = [
        pkgs.resvg # svg preview
        pkgs.poppler # pdf preview
        pkgs.ripdrag # drag-and-drop
      ];
      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        env=PATH="$PATH:/run/current-system/sw/bin"
        create_help_file=1
        default_dir=$HOME
        open_mode=suggested
        save_mode=suggested
      '';
      programs.yazi = {
        keymap = {
          mgr = {
            prepend_keymap = [
              {
                on = "y";
                run = [
                  "shell -- for path in %s; do echo \"file://$path\"; done | wl-copy -t text/uri-list"
                  "yank"
                ];
              }
              {
                on = "<C-n>";
                run = [
                  "shell -- ripdrag %s -x 2>/dev/null &"
                ];
              }
            ];
          };
        };
        settings = {
          open = {
            prepend_rules = [
              {
                mime = "application/executable";
                use = [
                  "run"
                ];
              }
              {
                mime = "application/pie-executable";
                use = [
                  "run"
                ];
              }
              {
                mime = "application/x-executable";
                use = [
                  "run"
                ];
              }
              {
                mime = "text/html";
                use = [
                  "open"
                  "edit"
                ];
              }
              {
                mime = "image/*";
                use = [
                  "open"
                  "set-wallpaper"
                ];
              }
            ];
            append_rules = [
              {
                url = "*"; # fallback
                use = [
                  "open"
                ];
              }
            ];
          };
          opener = {
            "run" = [
              {
                run = "app2unit -s a %s";
                desc = "Run";
                orphan = true;
                for = "linux";
              }
            ];
            "open" = [
              {
                run = "app2unit-open %s";
                desc = "Open";
                orphan = true;
                for = "linux";
              }
            ];
            "set-wallpaper" = [
              {
                run = "wallmaster set %s";
                desc = "Set as wallpaper";
                orphan = false;
                for = "linux";
              }
            ];
          };
        };
      };
    })
    (lib.mkIf nemo.enable {
      home.packages = [
        pkgs.nemo-with-extensions
        # cinnamon.nemo-emblems
        # cinnamon.nemo-fileroller
      ];
      desktop.scratchpads = {
        "Shift+Slash" = {
          criteria = {
            app_id = "nemo";
          };
          resize = 83;
          startup = "nemo";
          systemdCat = true;
          # autostart = true;
          # automove = true;
        };
      };
    })
    (lib.mkIf dolphin.enable {
      home.packages = [
        pkgs.qt6.qtwayland
        pkgs.kdePackages.dolphin
        pkgs.p7zip
      ]
      ++ (builtins.attrValues {
        inherit (pkgs.kdePackages)
          dolphin-plugins
          kdegraphics-thumbnailers
          ark
          ;
      });
      desktop.scratchpads = {
        "Shift+Slash" = {
          criteria = {
            app_id = "org.kde.dolphin";
          };
          resize = 83;
          startup = "dolphin";
          systemdCat = true;
        };
      };
    })
  ];
  meta = { };
}
