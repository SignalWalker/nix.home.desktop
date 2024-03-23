{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  dolphin = config.signal.desktop.explorer.dolphin;
  nemo = config.signal.desktop.explorer.nemo;
in {
  options = with lib; {
    signal.desktop.explorer = {
      dolphin = {
        enable = mkEnableOption "dolphin file explorer";
      };
      nemo = {
        enable = (mkEnableOption "nemo file explorer") // {default = !dolphin.enable;};
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    (lib.mkIf dolphin.enable {
      home.packages =
        (with pkgs.libsForQt5; [
          dolphin
          dolphin-plugins
          kdegraphics-thumbnailers
          ark
        ])
        ++ (with pkgs; [p7zip]);
      signal.desktop.scratch.scratchpads = {
        "Shift+Slash" = {
          criteria = {app_id = "org.kde.dolphin";};
          resize = 83;
          startup = "dolphin";
          systemdCat = true;
        };
      };
    })
    (lib.mkIf nemo.enable {
      home.packages = with pkgs; [
        cinnamon.nemo-with-extensions
        # cinnamon.nemo-emblems
        # cinnamon.nemo-fileroller
      ];
      signal.desktop.scratch.scratchpads."Shift+Slash" = {
        criteria = {app_id = "nemo";};
        resize = 83;
        startup = "nemo";
        systemdCat = true;
        # autostart = true;
        # automove = true;
      };
    })
  ];
  meta = {};
}
