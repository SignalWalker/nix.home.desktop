{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wln = config.desktop.wayland;
  ntf = wln.notifications;
  theme = config.desktop.theme;
  mako = config.services.mako;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkIf mako.enable {
    desktop.notifications = {
      commands = let
        makoctl = "${mako.package}/bin/makoctl";
      in {
        restore = "${makoctl} restore";
        dismiss = "${makoctl} dismiss";
        context = "${makoctl} menu ${pkgs.bemenu}/bin/bemenu -p mako";
      };
    };

    systemd.user.services."mako" = {
      Unit = {
        Description = "Mako notification daemon";
        Documentation = "man:mako(1)";
        PartOf = [wln.systemd.target];
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "mako";
      };
    };
    services.mako = let
      colors = theme.colors.signal;
    in {
      # mechanics
      actions = true;
      defaultTimeout = 5000;
      sort = "-priority";
      groupBy = "summary,body";

      maxVisible = -1;
      # theme
      ## default
      layer = "top";
      anchor = "bottom-right";

      width = floor (2256 / 6);
      height = floor (1504 / 8);

      font = let
        size = 11;
        fonts = theme.font.slab ++ theme.font.symbols;
      in
        std.concatStringsSep ", " (map (font: "${font.name} ${toString (font.selectSize size)}") fonts);
      # iconPath = std.concatStringsSep ":" [
      #   "${config.home.profileDirectory}/share/icons/hicolor"
      #   "${config.home.profileDirectory}/share/pixmaps"
      # ];
      backgroundColor = "#${colors.bg}aa";
      textColor = "#${colors.fg}";
      progressColor = "source #${colors.fg}";
      margin = "2";
      padding = "4";
      borderColor = "#${colors.border}";
      borderSize = 1;
      borderRadius = 0;
      ## extra
      extraConfig = ''
        outer-margin=12

        [urgency=low]
        background-color=#${colors.bg-low-priority}aa
        text-color=#${colors.fg-low-priority}
        progress-color=source #${colors.bg-low-priority-alt}aa

        [urgency=normal]
        background-color=#${colors.bg-normal-priority}aa
        text-color=#${colors.fg-normal-priority}
        progress-color=source #${colors.bg-normal-priority-alt}aa

        [urgency=critical]
        background-color=#${colors.bg-critical}aa
        text-color=#${colors.fg-critical}
        progress-color=source #${colors.bg-critical-alt}aa
        default-timeout=0
        ignore-timeout=1
        anchor=center
        layer=overlay

        [category="system"]
        anchor=bottom-left
        layer=overlay

        [app-name="watch-battery"]
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

