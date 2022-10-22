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
      actions = true;
      anchor = "bottom-right";
      sort = "-priority";
      groupBy = "summary,body";
      defaultTimeout = 5000;
      layer = "top";
      font = let
        size = 13;
        font = head (config.lib.signal.desktop.theme.bmpsAt size);
      in "${font.family} ${toString size}";
      # theme
      extraConfig = ''
        border-size=0
        border-radius=8

        [urgency=low]
        background-color=#1ea559aa
        text-color=#FFFFFFFF
        progress-color=source #6ae492aa

        [urgency=normal]
        background-color=#1877b7aa
        text-color=#FFFFFFFF
        progress-color=source #5ba6eaaa

        [urgency=critical]
        background-color=#b62460aa
        text-color=#FFFFFFFF
        progress-color=source #f66596aa
        default-timeout=0
        ignore-timeout=1
        anchor=center
        layer=overlay

        [category="system"]
        anchor=bottom-left
        layer=overlay

        [category="reminder"]
        anchor=center
        default-timeout=0
        layer=overlay

        [app-name="Cantata"]
        anchor=top-left
        layer=overlay

        [app-name="check-battery"]
        anchor=top-right
        default-timeout=0

        [app-name="check-battery" urgency=low]
        background-color=#b5a55faa
        text-color=#FFFFFFFF
        progress-color=source #cfbd75aa

        [app-name="hydrate"]
        text-alignment=center

        [app-name="light"]
        background-color=#b5a55faa
        text-color=#FFFFFFFF
        progress-color=source #cfbd75aa

        [app-name="Slack"]
        default-timeout=0
        ignore-timeout=1
        layer=overlay
      '';
    };
  };
  meta = {};
}