{
  config,
  lib,
  ...
}:
let
  cael = config.programs.caelestia;
in
{
  options = {
    programs.caelestia = {
      linkConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "if not null, ~/.config/caelestia/shell.json will be a symbolic link pointing to the given path";
      };
    };
  };
  config = lib.mkMerge [
    {
      programs.caelestia = {
        enable = true;
        systemd = {
          enable = true;
        };
        cli = {
          enable = true;
        };
        linkConfig = "/home/ash/projects/nix/home/desktop/src/wayland/shell/caelestia.json";
      };
      systemd.user.services.caelestia = {
        Unit = {
          Before = [ "tray.target" ];
          Wants = [ "tray.target" ];
        };
        Service.Slice = lib.mkForce "session-graphical.slice"; # provided by UWSM
        Install = {
          RequiredBy = [ "tray.target" ];
        };
      };
    }
    (lib.mkIf (cael.linkConfig != null) {
      assertions = [
        {
          assertion = cael.settings == { } && cael.extraConfig == "";
          message =
            let
              settingsStr = lib.generators.toKeyValue { } cael.settings;
            in
            "caelestia linkConfig is set, but settings or extraConfig are not empty: settings = ${settingsStr}, extraConfig = ${cael.extraConfig}";
        }
      ];
      warnings = [
        "linking ${config.xdg.configHome}/caelestia/shell.json -> ${cael.linkConfig}"
      ];
      home.activation."make-caelestia-cfg-symlink" =
        let
          cfgDir = "${config.xdg.configHome}/caelestia";
          cfgPath = "${cfgDir}/shell.json";
        in
        lib.hm.dag.entryAfter [ "WriteBoundary" ] ''
          run mkdir $VERBOSE_ARG -p ${cfgDir}
          run ln -fs $VERBOSE_ARG -T ${cael.linkConfig} ${cfgPath}
        '';
    })
    (lib.mkIf cael.enable {
      services.taskbar.enable = false;
      # services.watch-battery.enable = lib.mkForce false;
      services.swayosd.enable = false;
      desktop.wayland.idle.enable = false;
    })
    # generic keybinds
    {
      desktop.keybinds = {
        dashboardToggle = {
          modifiers = [ "MOD3" ];
          keysym = "B";
          description = "toggle shell dashboard";
        };
        sessionMenuToggle = {
          modifiers = [ "MOD3" ];
          keysym = "S";
          description = "toggle session menu";
        };
        controlCenterToggle = {
          modifiers = [
            "MOD3"
            "CTRL"
          ];
          keysym = "S";
          description = "toggle control center";
        };
      };
    }
    # caelestia-specific keybinds
    (lib.mkIf cael.enable {
      desktop.keybinds = {
        # shell
        dashboardToggle = {
          hypr = {
            enable = true;
            dispatcher = "global";
            args = [ "caelestia:dashboard" ];
          };
        };
        sessionMenuToggle = {
          hypr = {
            enable = true;
            dispatcher = "global";
            args = [ "caelestia:session" ];
          };
        };
        controlCenterToggle = {
          hypr = {
            enable = true;
            dispatcher = "global";
            args = [ "caelestia:controlCenter" ];
          };
        };
        # launcher

        # FIX :: caelestia doesn't let you use uwsm
        launcherRunAlt = {
          hypr = {
            dispatcher = "global";
            args = [ "caelestia:launcher" ];
          };
        };

        # screenshot
        screenshotArea = {
          hypr = {
            dispatcher = "global";
            args = [ "caelestia:screenshotFreeze" ];
          };
        };
        # notifications
        notificationsDismiss = {
          hypr = {
            enable = true;
            dispatcher = "global";
            args = [ "caelestia:clearNotifs" ];
          };
        };
        # media
        mediaPrev = {
          hypr = {
            dispatcher = "global";
            args = [ "caelestia:mediaPrev" ];
          };
        };
        mediaToggle = {
          hypr = {
            dispatcher = "global";
            args = [ "caelestia:mediaToggle" ];
          };
        };
        mediaNext = {
          hypr = {
            dispatcher = "global";
            args = [ "caelestia:mediaNext" ];
          };
        };
        # NOTE :: disabling this because it doesn't work as well as i'd like
        # # brightness
        # brightnessDown = {
        #   hypr = {
        #     dispatcher = "global";
        #     args = [ "caelestia:brightnessDown" ];
        #   };
        # };
        # brightnessUp = {
        #   hypr = {
        #     dispatcher = "global";
        #     args = [ "caelestia:brightnessUp" ];
        #   };
        # };
        # system
        sessionLock = {
          hypr = {
            dispatcher = "global";
            args = [ "caelestia:lock" ];
          };
        };
      };
    })
  ];
  meta = { };
}
