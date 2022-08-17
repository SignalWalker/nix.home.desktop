{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.X11;
in {
  options.services.X11.autorandr = with lib; {
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    programs.autorandr = let
      eDP = {
        fingerprint = "00ffffffffffff0009e5e80800000000251d0104a52213780754a5a7544c9b260f50540000000101010101010101010101010101010147798018713860403020360058c21000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e58310a00e0";
        config = {
          enable = true;
          primary = true;
          position = "0x0";
          mode = "1920x1080";
          rate = "120.00";
          crtc = 0;
        };
      };
    in {
      enable = true;
      profiles = {
        "default" = {
          fingerprint = {
            eDP = eDP.fingerprint;
          };
          config = {
            eDP = eDP.config;
          };
        };
        "desk" = {
          fingerprint = {
            eDP = eDP.fingerprint;
            HDMI-1-0 = "00ffffffffffff0010acbaa0534148300d1b010380342078ea0495a9554d9d26105054a54b00714f8180a940d1c0d100010101010101283c80a070b023403020360006442100001e000000ff00434656394e373351304841530a000000fc0044454c4c2055323431350a2020000000fd00313d1e5311000a2020202020200179020322f14f9005040302071601141f12132021222309070765030c00100083010000023a801871382d40582c450006442100001e011d8018711c1620582c250006442100009e011d007251d01e206e28550006442100001e8c0ad08a20e02d10103e960006442100001800000000000000000000000000000000000000000082";
          };
          config = {
            eDP = eDP.config // {position = "1920x120";};
            HDMI-1-0 = {
              enable = true;
              mode = "1920x1200";
              position = "0x0";
              rate = "59.95";
              crtc = 4;
            };
          };
        };
      };
    };
  };
}
