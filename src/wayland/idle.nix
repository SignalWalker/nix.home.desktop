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
  timeoutModule = types.submoduleWith {
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
            type = types.anything;
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
in {
  options.signal.desktop.wayland.idle = with lib; {
    enable = (mkEnableOption "wayland idle daemon") // {default = true;};
    events = {
      type = types.submoduleWith {
        modules = [
          ({
            config,
            lib,
            ...
          }: {
            freeformType = types.listOf types.str;
            options = {
              timeout = mkOption {
                type = types.listOf timeoutModule;
                default = [];
              };
              __toString = mkOption {
                type = types.anything;
                readOnly = true;
                default = self: let
                  evtsToStr = evt:
                    if evt == "timeout"
                    then (foldl' (acc: tmt: acc + "\n${evt} ${toString tmt}") "" self.${evt})
                    else (foldl' (acc: cmd: acc + "\n${evt} ${std.escapeShellArg cmd}") "" self.${evt});
                in
                  foldl' (acc: evt:
                    if evt == "__toString"
                    then acc
                    else acc + (evtsToStr evt)) "" (attrNames self);
              };
            };
          })
        ];
      };
      default = {};
    };
    settingsFile = mkOption {
      type = types.path;
      readOnly = true;
      default = pkgs.writeText "idle.conf" (toString idle.events);
    };
  };
  imports = [];
  config = lib.mkIf (wayland.enable && idle.enable) (lib.mkMerge [
    {
      systemd.user.services."wayland-idle" = {
        Unit = {
          Description = "Idle manager daemon for Wayland.";
          PartOf = [wayland.systemd.target];
        };
        Service = {
          ExecStart = "swayidle -w -C ${idle.settingsFile}";
        };
        Install = {
          WantedBy = [wayland.systemd.target];
        };
      };

      signal.desktop.wayland.idle.events = let
        lock = "swaylock -f";
        unlock = "killall swaylock";
        outputOn = "swaymsg \"output * dpms on\"";
        outputOff = "swaymsg \"output * dpms off\"";
      in {
        "before-sleep" = [
          "playerctl pause"
          lock
        ];
        "lock" = [lock];
        "unlock" = [unlock];
        "after-resume" = [outputOn];
        "timeout" = [
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
    }
  ]);
}
