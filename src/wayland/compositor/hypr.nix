{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  launcher = config.desktop.launcher;
in {
  options = with lib; {
  };
  disabledModules = [];
  imports = [];
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null; # FIX :: this only works if we're also using the nixos module
      portalPackage = null; # FIX :: this only works if we're also using the nixos module
      systemd = {
        enable = true; # TODO :: Is this necessary with USWM?
        enableXdgAutostart = false; # TODO :: Is this necessary with USWM?
      };
      settings = {
        general = {
          border_size = 1;
          gaps_in = 4;
          gaps_out = 4;
          allow_tearing = true; # NOTE :: must also set `immediate` windowrule to enable tearing
        };
        decoration = {
          rounding = 0;
          dim_inactive = false;
          screen_shader = ""; # TODO :: fragment shader lmao
          blur = {
            enabled = false;
          };
          shadow = {
            enabled = false;
            sharp = true;
          };
        };
        animations = {
          enabled = true;
          first_launch_animation = true;
        };
        input = {
          kb_model = "pc104";
          kb_layout = "hypersuper(us)";
          kb_options = "caps:hyper";
          natural_scroll = false; # NOTE :: this is *mouse* only; *not* touchpad
          # focus
          follow_mouse = 2;
          special_fallthrough = true;
          focus_on_close = 0;
          touchpad = {
            disable_while_typing = true;
            natural_scroll = true;
            clickfinger_behavior = true;
            tap_to_click = true;
            drag_lock = false;
          };
        };
        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };
        binds = {
          workspace_back_and_forth = true; # switch to previous workspace when trying to switch to current workspace
          focus_preferred_method = 1; # 1 = longer edges have priority
          movefocus_cycles_groupfirst = true;
          allow_pin_fullscreen = true;
        };
        xwayland = {
          enabled = true;
          use_nearest_neighbor = true;
          force_zero_scaling = true;
        };
        render = {
          direct_scanout = 2;
        };
        cursor = {
          no_warps = true;
        };
        ecosystem = {
          no_donation_nag = true;
        };
        bind =
          [
            "SUPER,Return,exec,kitty"

            "SUPERSHIFT,Q,killactive"
            "SUPERSHIFTCTRL,Q,forcekillactive"

            "SUPER,D,exec,${launcher.drun}"
            "SUPERALT,D,exec,${launcher.run}"

            "SUPERSHIFT,Space,togglefloating,current"

            "SUPER,F,fullscreen,0"
            "SUPERALT,F,fullscreen,1"

            "SUPERCTRL,P,pin,active"
            ",Print,exec,${config.desktop.wayland.screenshotScript} active"
            "CTRL,Print,exec,${config.desktop.wayland.screenshotScript} area"
            "SUPER,Print,exec,${config.desktop.wayland.screenshotScript} output"
            "SUPERALT,Print,exec,${config.desktop.wayland.screenshotScript} screen"

            "SUPER,N,exec,${ntf.restore}"
            "SUPERALT,N,exec,${ntf.dismiss}"
            "SUPERCTRL,N,exec,${ntf.context}"

            "SUPERALT,W,exec,${config.desktop.wayland.wallpaper.randomizeCmd}"
            "SUPERALT,L,exec,swaylock --effect-scale 0.5 --effect-blur 5x3"

            ",XF86MonBrightnessUp,exec,light -A 2"
            ",XF86MonBrightnessDown,exec,light -U 2"
            "CTRL,XF86MonBrightnessUp,exec,light -S 100"
            "CTRL,XF86MonBrightnessDown,exec,light -S 1"

            "XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +1dB" # using pactl isntead of wpctl because it accepts dB, which preserves L/R balance ratio
            "XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -1dB"
            "XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            "ALT,XF86AudioRaiseVolume,exec,wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02+"
            "ALT,XF86AudioLowerVolume,exec,wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02-"
            "XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            "ALT,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ]
          ++ (foldl'
            (acc: space: let
              key = toString (space - 1);
            in
              acc
              ++ [
                "SUPER,${key},workspace,${key}"
                "SUPERSHIFT,${key},movetoworkspacesilent,${key}"
              ])
            []
            (genList (i: i + 1) 10));
      };
    };
  };
  meta = {};
}
