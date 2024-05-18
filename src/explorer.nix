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
  thunar = config.signal.desktop.explorer.thunar;
in {
  options = with lib; {
    signal.desktop.explorer = {
      dolphin = {
        enable = (mkEnableOption "dolphin file explorer") // {default = false;};
      };
      nemo = {
        enable = (mkEnableOption "nemo file explorer") // {default = !dolphin.enable;};
      };
      thunar = {
        enable = (mkEnableOption "thunar file explorer") // {default = (!dolphin.enable) && (!nemo.enable);};
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    (lib.mkIf dolphin.enable {
      home.packages =
        [
          pkgs.qt6.qtwayland
          pkgs.kdePackages.dolphin
        ]
        ++ (with pkgs.kdePackages; [
          dolphin-plugins
          kdegraphics-thumbnailers
          ark
        ])
        ++ (with pkgs; [
          p7zip
        ]);
      desktop.scratchpads = {
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
      desktop.scratchpads = {
        "Shift+Slash" = {
          criteria = {app_id = "nemo";};
          resize = 83;
          startup = "nemo";
          systemdCat = true;
          # autostart = true;
          # automove = true;
        };
      };
    })
  ];
  meta = {};
}