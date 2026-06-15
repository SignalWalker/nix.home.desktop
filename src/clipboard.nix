{
  config,
  lib,
  ...
}:
{
  config = {
    services.clipse = {
      enable = lib.mkDefault true;
      systemdTarget = config.wayland.systemd.target;
      imageDisplay = {
        type = "kitty";
      };
    };
    desktop.windows = [
      {
        criteria = {
          appId = "clipse";
        };
        properties = {
          float = true;
          size = {
            width = "622";
            height = "652";
          };
        };
      }
    ];
    desktop.keybinds = {
      clipboardHistoryShow = {
        modifiers = [ "MOD3" ];
        keysym = "V";
        description = "show clipboard history";
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "exec_raw";
          args = lib.mkDefault [ "app2unit -s a -a clipse -- kitty --app-id=clipse clipse" ];
        };
      };
    };
  };
}