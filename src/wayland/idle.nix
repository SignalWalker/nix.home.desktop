{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wayland = config.signal.desktop.wayland;
  idle = wayland.idle;
  swayidle = config.services.swayidle;
  timeoutModule = lib.types.submoduleWith {
    modules = [
      ({
        config,
        lib,
        ...
      }: {
        options = with lib; {
          timeout = mkOption {
            type = types.int;
          };
          command = mkOption {
            type = types.str;
          };
          resume = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          __toString = mkOption {
            type = types.raw;
            readOnly = true;
            default = self:
              "${toString self.timeout} ${std.escapeShellArg self.command}"
              + (
                if self.resume != null
                then " resume ${std.escapeShellArg self.resume}"
                else ""
              );
          };
        };
      })
    ];
  };
  swayidleSettingsModule = lib.types.submoduleWith {
    modules = [
      ({
        config,
        lib,
        ...
      }: {
        options = with lib; let
          mkEvent = args:
            mkOption ({
                type = types.listOf types.str;
                default = [];
              }
              // args);
        in {
          timeout = mkOption {
            type = types.listOf timeoutModule;
            default = [];
          };
          before-sleep = mkEvent {};
          after-resume = mkEvent {};
          lock = mkEvent {};
          unlock = mkEvent {};
          idlehint = mkOption {
            type = types.nullOr types.int;
            default = null;
          };
          __toString = mkOption {
            type = types.raw;
            readOnly = true;
            default = self: let
              evtsToStr = event:
                assert isString event; let
                  entries = self.${event};
                in
                  assert isList entries;
                    if event == "timeout"
                    then (foldl' (acc: tmt: acc + "\ntimeout ${toString tmt}") "" entries)
                    else (foldl' (acc: cmd: assert isString cmd; acc + "\n${event} ${std.escapeShellArg cmd}") "" entries);
            in
              foldl' (
                acc: event:
                  if (event == "idlehint")
                  then acc + (std.optionalString (self.idlehint != null) "\nidlehint ${toString self.idlehint}")
                  else if event == "__toString"
                  then acc
                  else acc + (evtsToStr event)
              ) "" (attrNames self);
          };
        };
      })
    ];
  };
in {
  options.signal.desktop.wayland.idle = with lib; {
    enable = (mkEnableOption "wayland idle daemon") // {default = true;};
    settings = mkOption {
      type = swayidleSettingsModule;
      default = {};
    };
  };
  imports = [];
  config =
    lib.mkIf (wayland.enable && idle.enable)
    {
      xdg.configFile."swayidle/config".text = toString idle.settings;
      systemd.user.services."wayland-idle" = {
        Unit = {
          Description = "Idle manager daemon for Wayland.";
          PartOf = [wayland.systemd.target];
        };
        Service = {
          ExecStart = "swayidle -w";
        };
        Install = {
          WantedBy = [wayland.systemd.target];
        };
      };

      signal.desktop.wayland.idle.settings = let
        lock = "swaylock -f";
        outputOn = "swaymsg \"output * dpms on\"";
        outputOff = "swaymsg \"output * dpms off\"";
      in {
        before-sleep = [
          "playerctl pause"
          lock
        ];
        lock = [lock];
        timeout = [
          {
            timeout = 60;
            command = "if pgrep -x swaylock; then ${outputOff}; fi";
            resume = outputOn;
          }
          {
            timeout = 900;
            command = outputOff;
            resume = outputOn;
          }
        ];
      };
    };
}
