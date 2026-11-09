{
  config,
  lib,
  ...
}:
let
  noctalia = config.programs.noctalia;
in
{
  options = { };
  disabledModules = [ "programs/noctalia" ];
  imports = [ ];
  config = lib.mkIf noctalia.enable {
    services.taskbar.enable = false;
    services.swayosd.enable = false;
    desktop.wayland.idle.enable = false;
    services.clipse.enable = false;

    stylix.targets.noctalia.enable = false;

    programs.noctalia = {
      systemd.enable = true;
      settings = {
        shell = {
          setup_wizard_enabled = false;
          telemetry_enabled = true; # sure why not
          avatar_path = "${config.home.homeDirectory}/.face";
          clipboard_enabled = true;
          polkit_agent = true; # sure why not
          launch_apps_as_systemd_services = true;
          screen_time_enabled = true;
          umbriel_audio_provider_enabled = true;
          # corner_radius_scale = 0.0;
          panel = {
            transparency_mode = "glass"; # fuck it let's be windows 7
            launcher_placement = "floating";
            launcher_position = "center";
            clipboard_placement = "floating";
            clipboard_position = "auto";
            control_center_placement = "floating";
            session_placement = "centered";
          };
          launcher = {
            fetch_exchange_rates = false;
          };
          greeter_sync = {
            auto_sync = true;
          };
          screenshot = {
            format = "jxl";
            quality = 100;
            directory = "${config.xdg.userDirs.pictures}/screenshots";
        };
          session = {
            actions = [
              {
                action = "lock";
                shortcut = "1";
              }
              {
                action = "logout";
                shortcut = "2";
              }
              {
                action = "reboot";
                shortcut = "3";
              }
              {
                action = "shutdown";
                destructive = true;
                shortcut = "4";
              }
            ];
          };
        };
        control_center = {
          sidebar_section = "none";
          circular_avatar = false;
          show_avatar_border = false;
        };
        theme = {
          mode = "auto";
          source = "wallpaper"; # wallmaster handles this
          wallpaper_scheme = "faithful";
          templates = {
            enable_builtin_templates = true;
            builtin_ids = [ "umbriel" ];
          };
        };
        wallpaper = {
          enabled = false;
        };
        location = {
          auto_locate = true;
          address = "Seattle, WA";
        };
        nightlight = {
          enabled = true;
        };
        weather = {
          enabled = true;
        };
        lockscreen = {
          blurred_desktop = false; # just use the wallpaper
          blur_intensity = 0.0;
        };
        notification = {
          enable_daemon = true;
          layer = "overlay";
          history_retention_hours = 24;
          follow_focused_output = true;
        };
        brightness = {
          enable_ddcutil = true;
          sync_all_monitors = true;
        };
        audio = {
          enable_notification_sounds = false;
        };
        idle = {
          behavior = {
            "lock" = {
              timeout = 720;
              command = "noctalia:session lock";
              enabled = true;
            };
            "screen-off" = {
              timeout = 600;
              command = "noctalia:dpms-off";
              resume_command = "noctalia:dpms-on";
              enabled = true;
            };
          };
        };
        battery = {
          warning_threshold = 15;
        };
        bar = {
          order = [ "main" ];
          "main" = {
            position = "right";
            margin_edge = config.wayland.windowManager.hyprland.settings.general.gaps_out or 4;
            background_opacity = 0.8;
            auto_hide = true;
            reserve_space = false;
            monitor = {
              "vertical" = {
                match = "Dell Inc. DELL U2415 CFV9N7AJ21LS";
                position = "top";
                auto_hide = true;
                reserve_space = false;
              };
            };
            start = [
              "clock"
              "notifications"
              "clipboard"
              "workspaces"
            ];
            center = [
              "media"
            ];
            end = [
              "tray"
              "network"
              "bluetooth"
              "volume"
              "brightness"
              "nightlight"
              "caffeine"
              "wallmaster-override"
              "battery"
              "power-profile"
              "session"
            ];
          };
        };
        widget = {
          "media" = {
            hide_when_no_media = true;
          };
          "wallmaster-override" = {
            left = "wallmaster toggle-override";
            glyph = "mountain";
            tooltip = "Toggle wallmaster animation preference";
            type = "custom_button";
          };
        };
        # not touching widgets rn because they're positioned by logical pixels
        desktop_widgets = {
          enabled = false;
        };
      };
    };
    desktop.keybinds =
      let
        msg = "noctalia msg";
      in
      {
        systemMonitorOpen = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = ["${msg} panel-toggle control-center system"];
          };
        };
        brightnessDown = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = ["${msg} brightness-down"];
          };
        };
        brightnessUp = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = ["${msg} brightness-up"];
          };
        };
        launcherRun = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle launcher" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle launcher" ];
          };
        };
        sessionLock = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} session lock" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} session lock" ];
          };
        };
        clipboardHistoryShow = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle clipboard" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle clipboard" ];
          };
        };
        notificationsRestore = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle control-center notifications" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center notifications" ];
          };
        };
        notificationsDismiss = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} notification-clear-active" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} notification-clear-active" ];
          };
        };
        controlCenterToggle = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle control-center" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center" ];
          };
        };
        sessionMenuToggle = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle session" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle session" ];
          };
        };
        dashboardToggle = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle control-center" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center" ];
          };
        };
        weatherToggle = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle control-center weather" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center weather" ];
          };
        };
        # bluetoothMenuToggle = {
        #   hypr = {
        #     enable = true;
        #     dispatcher = "exec_raw";
        #     args = [ "${msg} panel-toggle control-center bluetooth" ];
        #   };
        # };
        networkMenuToggle = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = [ "${msg} panel-toggle control-center network" ];
          };
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center network" ];
          };
        };

        screenshotActive = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = ["${msg} screenshot-window"];
          };
        };
        screenshotArea = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = ["${msg} screenshot-region"];
          };
        };
        screenshotOutput = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = ["${msg} screenshot-fullscreen"];
          };
        };
        screenshotAll = {
          umbriel = {
            enable = true;
            action = "spawn";
            args = ["${msg} screenshot-fullscreen all"];
          };
        };
      };
  };
  meta = { };
}
