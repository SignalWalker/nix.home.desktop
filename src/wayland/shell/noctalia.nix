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
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf noctalia.enable {
    services.taskbar.enable = false;
    services.swayosd.enable = false;
    desktop.wayland.idle.enable = false;
    services.clipse.enable = false;

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
          panel = {
            transparency_mode = "glass"; # fuck it let's be windows 7
            launcher_placement = "floating";
            clipboard_placement = "floating";
            control_center_placement = "floating";
            session_placement = "centered";
          };
          session = {
            actions = [
              {
                action = "lock";
                # command = builtins.head config.desktop.keybinds.sessionLock.hypr.args;
                shortcut = "1";
              }
              {
                action = "logout";
                # command = "loginctl terminate-user \"\""; # the explicit empty string makes it terminate the current user
                shortcut = "2";
              }
              {
                action = "reboot";
                shortcut = "3";
              }
              {
                action = "shutdown";
                # command = "systemctl poweroff";
                destructive = true;
                shortcut = "4";
              }
            ];
          };
        };
        control_center = {
          sidebar_section = "none";
        };
        theme = {
          mode = "auto";
          source = "wallpaper"; # wallmaster handles this
          wallpaper_scheme = "faithful";
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
        notifications = {
          enable_daemon = true;
          layer = "overlay";
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
            position = "left";
            margin_edge = config.wayland.windowManager.hyprland.settings.general.gaps_out or 4;
            background_opacity = 0.8;
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
            command = "wallmaster toggle-override";
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
        launcherRunAlt = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle launcher" ];
          };
        };
        sessionLock = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} session lock" ];
          };
        };
        clipboardHistoryShow = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle clipboard" ];
          };
        };
        notificationsRestore = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center notifications" ];
          };
        };
        notificationsDismiss = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} notification-clear-active" ];
          };
        };
        controlCenterToggle = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center" ];
          };
        };
        sessionMenuToggle = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle session" ];
          };
        };
        dashboardToggle = {
          hypr = {
            enable = true;
            dispatcher = "exec_raw";
            args = [ "${msg} panel-toggle control-center" ];
          };
        };
      };
  };
  meta = { };
}