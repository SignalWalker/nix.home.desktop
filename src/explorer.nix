{
  pkgs,
  ...
}:
{
  options = {
  };
  disabledModules = [ ];
  imports = [ ];
  config = {
    programs.app2unit.enable = true;
    home.packages = [
      pkgs.resvg # svg preview
      pkgs.poppler # pdf preview
      pkgs.ripdrag # drag-and-drop
      pkgs.kdePackages.kdialog # TODO :: why
    ];
    desktop.scratchpads = {
      "Shift+Slash" = {
        criteria = {
          app_id = "scratch_explorer";
        };
        resize = 83;
        startup = "kitty --class scratch_explorer yazi";
        systemdCat = true;
        autostart = false;
        automove = true;
      };
    };
    desktop.windows = {
      termFileChooser = {
        criteria = {
          # this is set in ${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          initialTitle = "termfilechooser";
        };
        effects = {
          hypr.static = {
            float = true;
            center = true;
            size = {
              x = "monitor_w * 0.5";
              y = "monitor_h * 0.5";
            };
          };
        };
      };
    };
    # this makes XDG use yazi as the file selector
    # NOTE :: the PATH line is a workaround for NixOS: https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser/issues/56#issuecomment-3697512117
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
  };
  meta = { };
}
