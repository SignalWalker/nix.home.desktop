{
  config,
  pkgs,
  lib,
  ...
}:
let
  dolphin = config.signal.desktop.explorer.dolphin;
  nemo = config.signal.desktop.explorer.nemo;
  yazi = config.programs.yazi;
in
{
  options = {
    signal.desktop.explorer = {
      dolphin = {
        enable = (lib.mkEnableOption "dolphin file explorer") // {
          default = false;
        };
      };
      nemo = {
        enable = (lib.mkEnableOption "nemo file explorer") // {
          default = !dolphin.enable;
        };
      };
      thunar = {
        enable = (lib.mkEnableOption "thunar file explorer") // {
          default = (!dolphin.enable) && (!nemo.enable);
        };
      };
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkMerge [
    {
      home.packages = [
        # TODO :: why
        pkgs.kdePackages.kdialog
      ];
    }
    (lib.mkIf yazi.enable {
      programs.app2unit.enable = true;
      home.packages = [
        pkgs.resvg # svg preview
        pkgs.poppler # pdf preview
      ];
      programs.yazi = {
        settings = {
          opener = {
            "open" = [
              {
                run = "app2unit-open $@";
                desc = "Open";
              }
            ];
          };
        };
      };
    })
    (lib.mkIf nemo.enable {
      home.packages = [
        pkgs.nemo-with-extensions
        # cinnamon.nemo-emblems
        # cinnamon.nemo-fileroller
      ];
      desktop.scratchpads = {
        "Shift+Slash" = {
          criteria = {
            app_id = "nemo";
          };
          resize = 83;
          startup = "nemo";
          systemdCat = true;
          # autostart = true;
          # automove = true;
        };
      };
    })
    (lib.mkIf dolphin.enable {
      home.packages = [
        pkgs.qt6.qtwayland
        pkgs.kdePackages.dolphin
        pkgs.p7zip
      ]
      ++ (builtins.attrValues {
        inherit (pkgs.kdePackages)
          dolphin-plugins
          kdegraphics-thumbnailers
          ark
          ;
      });
      desktop.scratchpads = {
        "Shift+Slash" = {
          criteria = {
            app_id = "org.kde.dolphin";
          };
          resize = 83;
          startup = "dolphin";
          systemdCat = true;
        };
      };
    })
  ];
  meta = { };
}
