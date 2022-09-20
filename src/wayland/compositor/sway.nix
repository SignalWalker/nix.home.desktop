{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland.compositor.sway;
in {
  options.signal.desktop.wayland.compositor.sway = with lib; {
    enable = mkEnableOption "sway wayland compositor";
  };
  imports = [];
  config = lib.mkIf (config.signal.desktop.wayland.enable && cfg.enable) {
    wayland.windowManager.sway = let
      mod = "Mod4";
      menu = config.signal.desktop.wayland.menu.defaultCommand;
      up = "k";
      down = "j";
      left = "h";
      right = "l";
    in {
      enable = true;
      package = lib.mkIf (!config.system.isNixOS) (pkgs.sway.override {
        sway-unwrapped = pkgs.lib.makeOverridable ({
          isNixOS ? null,
          enableXWayland ? null,
        }:
          (lib.signal.home.linkSystemApp pkgs {app = "sway";})
          // {
            version = "system";
          }) {};
        extraSessionCommands = config.wayland.windowManager.sway.extraSessionCommands;
        extraOptions = config.wayland.windowManager.sway.extraOptions;
        withBaseWrapper = config.wayland.windowManager.sway.wrapperFeatures.base;
        withGtkWrapper = config.wayland.windowManager.sway.wrapperFeatures.gtk;
      });
      config = {
        bars = [
          # {
          #   command = "waybar";
          #   position = "top";

          #   # font = "pango:scientifica 8";
          #   # pango_markup = "enabled";

          #   mode = "dock";

          #   # status_command = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";

          #   colors = {
          #     statusline = "#ffffff";
          #     background = "#323232";
          #     # inactive_workspace = "#32323200 #32323200 #5c5c5c";
          #   };
          # }
        ];
        assigns = {};
        colors = {};
        floating = {};
        fonts = {};
        gaps = {
          inner = 2;
          outer = 4;
          smartBorders = "on";
          smartGaps = true;
        };
        output = {
          "*" = {
            adaptive_sync = "on";
            scale_filter = "nearest";
          };
        };
        seat = {};
        window = {
          border = 1;
          hideEdgeBorders = "smart";
          commands = [];
        };
        modifier = mod;
        workspaceAutoBackAndForth = true;
        input = {
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            accel_profile = "adaptive";
            dwt = "enabled";
          };
          "type:pointer" = {
            accel_profile = "adaptive";
          };
          "type:keyboard" = {
            xkb_layout = "us";
            xkb_capslock = "disabled";
            xkb_numlock = "enabled";
            xkb_options = "caps:none";
          };
        };
        focus = {
          followMouse = "no";
          forceWrapping = true;
          mouseWarping = false;
        };
        inherit up down left right;
        keybindings = let
          dirMap = {
            inherit up down left right;
          };
        in
          {
            "${mod}+Return" = "exec kitty";
            "${mod}+Shift+q" = "kill";
            "${mod}+d" = "exec ${menu}";
            "${mod}+Ctrl+r" = "reload";
            "${mod}+Ctrl+Alt+Shift+q" = "exec swaymsg exit";

            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";

            "${mod}+s" = "layout stacking";
            "${mod}+Tab" = "layout tabbed";

            "${mod}+minus" = "scratchpad show";
            "${mod}+Shift+minus" = "move scratchpad";

            "${mod}+f" = "fullscreen";

            "${mod}+w" = "mode split";
            "${mod}+r" = "mode resize";

            "XF86MonBrightnessUp" = "exec light -A 5";
            "XF86MonBrightnessDown" = "exec light -U 5";
            "Ctrl+XF86MonBrightnessUp" = "exec light -S 100";
            "Ctrl+XF86MonBrightnessDown" = "exec light -S 1";
            "${mod}+XF86MonBrightnessUp" = "opacity plus 0.02";
            "${mod}+XF86MonBrightnessDown" = "opacity minus 0.02";
            "${mod}+Ctrl+XF86MonBrightnessUp" = "opacity set 1";

            "XF86AudioPrev" = "exec playerctl -s previous";
            "XF86AudioPlay" = "exec playerctl -s play-pause";
            "XF86AudioNext" = "exec playerctl -s next";

            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +2%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -2%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "Alt+XF86AudioRaiseVolume" = "exec pactl set-source-volume @DEFAULT_SOURCE@ +2%";
            "Alt+XF86AudioLowerVolume" = "exec pactl set-source-volume @DEFAULT_SOURCE@ -2%";
            "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

            "${mod}+Ctrl+b" = "border toggle";
            "${mod}+Ctrl+p" = "sticky toggle";

            "${mod}+Shift+s" = "exec ${config.signal.desktop.wayland.screenshotCmd}";

            "${mod}+n" = "exec makoctl restore";
            "${mod}+Ctrl+n" = "exec makoctl dismiss";
            "${mod}+Shift+Ctrl+n" = "exec makoctl dismiss -a";
            "${mod}+Alt+n" = "exec makoctl invoke on-button-left";

            "${mod}+Alt+l" = "exec swaylock";
          }
          // (foldl' (acc: dir: let
            key = dirMap.${dir};
          in
            acc
            // {
              "${mod}+${key}" = "focus ${dir}";
              "${mod}+Shift+${key}" = "move ${dir}";
            }) {} (attrNames dirMap))
          // (foldl' (acc: space: let
            key = toString (space - 1);
          in
            acc
            // {
              "${mod}+${key}" = "workspace number ${key}";
              "${mod}+Shift+${key}" = "move container to workspace number ${key}";
            }) {} (genList (i: i + 1) 10));
        modes = {
          "split" = {
            "${mod}+s" = "splith; mode default";
            "${mod}+v" = "splitv; mode default";
            "Escape" = "mode default";
          };
          "resize" = {
            "${mod}+${left}" = "resize shrink width 10px";
            "${mod}+${right}" = "resize grow width 10px";
            "${mod}+${up}" = "resize shrink height 10px";
            "${mod}+${down}" = "resize grow height 10px";

            "${mod}+c" = "resize set width 50 ppt height 50 ppt; move position center";
            "${mod}+Ctrl+c" = "resize set width 75 ppt height 75 ppt; move position center";
            "${mod}+Shift+c" = "resize set width 83 ppt height 83 ppt; move position center";

            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };
        terminal = "kitty";
        inherit menu;
        defaultWorkspace = "workspace number 1";
        startup = [
          {command = "${config.signal.desktop.wayland.__systemdStartupScript}";}
        ];
      };
      swaynag = {
        enable = true;
        settings = {};
      };
      systemdIntegration = false;
      extraConfig = ''
        bindswitch --reload --locked {
          lid:on output eDP-1 dpms off
          lid:off output eDP-1 dpms on
        }
      '';
      extraSessionCommands = let
        vars = config.signal.desktop.wayland.sessionVariables;
        keys = attrNames vars;
      in
        concatStringsSep "\n" (map (key: "export ${key}=\"${toString vars.${key}}\"") keys);
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      xwayland = config.signal.desktop.wayland.xwayland.enable;
    };
  };
}
