{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wln = config.signal.desktop.wayland;
  ntf = wln.notifications;
  theme = config.signal.desktop.theme;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkIf (wln.enable && ntf.enable) {
    systemd.user.services."mako" = {
      Unit = {
        Description = "Mako notification daemon";
        Documentation = "man:mako(1)";
        PartOf = ["wayland-session.target"];
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "mako";
      };
    };
    programs.mako = {
      enable = ntf.enable;
      # mechanics
      actions = true;
      defaultTimeout = 5000;
      sort = "-priority";
      groupBy = "summary,body";
      # theme
      ## default
      layer = "top";
      anchor = "bottom-right";
      font = let
        size = 11;
        fonts = theme.font.slab ++ theme.font.symbols;
      in "${std.concatStringsSep ", " (map (font: font.name) fonts)} ${toString size}";
      iconPath = std.concatStringsSep ":" [
        "${config.home.profileDirectory}/share/icons/hicolor"
        "${config.home.profileDirectory}/share/pixmaps"
      ];
      ## extra
      extraConfig = let
        colors = theme.colors.signal;
      in ''
        background-color=#${colors.bg}aa
        text-color=#${colors.fg}
        progress-color=source #${colors.fg}

        padding=4

        border-color=#${colors.border}
        border-size=1
        border-radius=0

        [urgency=low]
        background-color=#${colors.bg-low-priority}aa
        text-color=#${colors.fg}
        progress-color=source #${colors.cyan}

        [urgency=normal]
        background-color=#${colors.bg-normal-priority}aa
        text-color=#${colors.fg}
        progress-color=source #${colors.dark-grey}

        [urgency=critical]
        background-color=#${colors.bg-critical}aa
        text-color=#${colors.fg}
        progress-color=source #${colors.yellow}
        default-timeout=0
        ignore-timeout=1
        anchor=center
        layer=overlay

        [category="system"]
        anchor=bottom-left
        layer=overlay

        [app-name="check-battery"]
        anchor=top-right
        default-timeout=0

        [app-name="light"]
        background-color=#${colors.yellow}aa
        text-color=#${colors.fg}

        [app-name="Slack"]
        default-timeout=0
        ignore-timeout=1
        layer=overlay

        [app-name="Discord"]
        layer=overlay

        [app-name="Quod Libet"]
        anchor=bottom-left
        group-by=app-name
      '';
    };
  };
  meta = {};
}
