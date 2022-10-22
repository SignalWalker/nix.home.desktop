inputs @ {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  cfg = config.signal.desktop.terminal;
  kcfg = config.signal.desktop.terminal.kitty;
in {
  options.signal.desktop.terminal.kitty = with lib; {};
  config = lib.mkIf (cfg.app == "kitty") {
    xdg.configFile."kitty/open-actions.conf".source = ./kitty/open-actions.conf;
    xdg.binFile."hg" = {
      executable = true;
      source = ./kitty/hg;
    };
    programs.zsh = {
      initExtra = ''
        compdef _rg hg
        if [[ "$TERM" = "${config.programs.kitty.settings.term}" ]]; then
          alias ssh="kitty +kitten ssh"
          alias icat="kitty +kitten icat"
          alias kdiff="kitty +kitten diff"
          alias ksync="kitty +kitten transfer"
          alias kdeltas="kitty +kitten transfer --transmit-deltas"
        fi
      '';
    };
    programs.kitty = {
      enable = true;
      package =
        if (config.system.isNixOS or true)
        then pkgs.kitty
        else (lib.signal.home.linkSystemApp pkgs {app = "kitty";});
      environment = {};
      font = let
        font = head config.signal.desktop.theme.font.terminal;
      in {
        inherit (font) package;
        name = font.family;
        size = 10;
      };
      theme = "Gruvbox Material Dark Hard";
      settings = {
        # scrollback
        scrollback_lines = 10000;
        scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
        scrollback_pager_history_size = 0;
        scrollback_fill_enlarged_window = true;
        wheel_scroll_multiplier = "5.0";
        # performance
        repaint_delay = 8;
        input_delay = 1;
        sync_to_monitor = true;
        # bell
        enable_audio_bell = false;
        visual_bell_duration = "0.0";
        window_alert_on_bell = true;
        bell_on_tab = "🔔 ";
        # command_on_bell = "sh -c 'notify-send -h string:x-dunst-stack-tag:terminal-bell -i ${resources.pond} -c terminal,bell -a kitty $KITTY_CHILD_CMDLINE'";
        # advanced
        shell = ".";
        editor = ".";
        close_on_child_death = false;
        allow_remote_control = "socket-only";
        listen_on = "none";
        update_check_interval = 0;
        clipboard_control = "write-clipboard write-primary read-clipboard-ask read-primary-ask";
        clipboard_max_size = 128;
        allow_hyperlinks = true;
        shell_integration = "enabled";
        term = "xterm-kitty";
        # os
        linux_display_server = "auto";
        # background
        background_opacity = "0.8";
        dynamic_background_opacity = false;
        background_tint = "0.2";
        # text
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        force_ltr = false;
        disable_ligatures = "never";
        box_drawing_scale = "0.001, 1, 1.5, 2";
        # cursor
        cursor_shape = "block";
        # layout
        enabled_layouts = "splits";
        draw_minimal_borders = true;
        # tab bar
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        ## keyboard
        kitty_mod = "super"; # note: this is actually Mod4, which is Hyper_L when using the keyboard settings defined in this flake (kitty considers Hyper_L to be numlock, for some reason)
        ## mouse
        mouse_hide_wait = "3.0";
        detect_urls = true;
        url_prefixes = "http https file ftp gemini irc gopher mailto news git";
        copy_on_select = false;
        focus_follows_mouse = false;
        # input
        clear_all_shortcuts = true;
        clear_all_mouse_actions = true;
      };

      extraConfig = ''
        mouse_map left click ungrabbed mouse_handle_click selection link prompt
        mouse_map kitty_mod+left release grabbed,ungrabbed mouse_handle_click link
        mouse_map kitty_mod+left press grabbed discard_event
        mouse_map left press ungrabbed mouse_selection normal
        mouse_map right press ungrabbed mouse_select_command_output
        mouse_map kitty_mod+right press ungrabbed mouse_show_command_output
      '';

      keybindings = let
        vlaunch = "launch --location=vsplit";
        hlaunch = "launch --location=hsplit";
      in {
        # clipboard
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+c" = "copy_and_clear_or_interrupt";
        # windows
        "kitty_mod+v" = "${vlaunch} --cwd=current";
        "kitty_mod+s" = "${hlaunch} --cwd=current";
        "kitty_mod+ctrl+v" = vlaunch;
        "kitty_mod+ctrl+s" = hlaunch;
        "kitty_mod+w" = "close_window";
        "kitty_mod+r" = "start_resizing_window";
        "kitty_mod+h" = "neighboring_window left";
        "kitty_mod+j" = "neighboring_window down";
        "kitty_mod+k" = "neighboring_window up";
        "kitty_mod+l" = "neighboring_window right";
        # tabs
        "kitty_mod+alt+h" = "previous_tab";
        "kitty_mod+alt+l" = "next_tab";
        "kitty_mod+alt+v" = "new_tab_with_cwd";
        "kitty_mod+alt+w" = "close_tab";
        "kitty_mod+alt+ctrl+h" = "move_tab_backward";
        "kitty_mod+alt+ctrl+l" = "move_tab_forward";
        # history
        "kitty_mod+/" = "show_scrollback";
        "kitty_mod+alt+/" = "show_last_command_output";
        "kitty_mod+home" = "scroll_home";
        "kitty_mod+end" = "scroll_end";
        "kitty_mod+Page_Up" = "scroll_page_up";
        "kitty_mod+Page_Down" = "scroll_page_down";
        "kitty_mod+alt+Page_Up" = "scroll_to_prompt -1";
        "kitty_mod+alt+Page_Down" = "scroll_to_prompt 1";
        "kitty_mod+delete" = "clear_terminal scrollback active";
      };
    };
  };
}
