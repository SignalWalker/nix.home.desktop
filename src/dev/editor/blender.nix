{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    desktop.windows = {
      blenderSizeFileView = {
        criteria = {
          initialClass = "blender";
          initialTitle = "File Browser";
        };
        effects = {
          hypr.static = {
            float = true;
            size = {
              x = "monitor_w * 0.5";
              y = "monitor_h * 0.5";
            };
          };
          hypr.dynamic = {
            persistentSize = true;
          };
        };
      };
      blenderSizePreferences = {
        criteria = {
          initialClass = "blender";
          initialTitle = "Preferences";
        };
        effects = {
          hypr.static = {
            float = true;
            size = {
              x = "monitor_w * 0.5";
              y = "monitor_h * 0.5";
            };
          };
          hypr.dynamic = {
            persistentSize = true;
          };
        };
      };
    };
  };
}
