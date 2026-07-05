{
  ...
}:
{
  config = {
    desktop.windows = {
      godotFixScrollFactor = {
        criteria = {
          initialClass = "org.godotengine.Editor";
        };
        effects = {
          hypr.dynamic.scrollTouchpad = 0.05;
        };
      };
      godotFixGameWindow = {
        criteria = {
          initialClass = "org.godotengine.Editor";
          initialTitle = ".*DEBUG.*";
        };
        effects = {
          hypr.static = {
            float = true;
            size = {
              x = "monitor_w * 0.25";
              y = "monitor_h * 0.25";
            };
          };
          hypr.dynamic = {
            persistentSize = true;
          };
        };
      };
    };
  };
  meta = { };
}
