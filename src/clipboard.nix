{
  config,
  ...
}:
{
  config = {
    services.clipse = {
      enable = true;
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
          dispatcher = "execr";
          args = [ "uwsm-app -s a -a clipse kitty --app-id=clipse clipse" ];
        };
      };
    };
  };
}
