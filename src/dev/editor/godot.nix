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
      godotFloatGameWindow = {
        criteria = {
          initialClass = "org.godotengine.Editor";
          title = ".*DEBUG.*";
        };
        effects = {
          hypr.static.float = true;
        };
      };
    };
  };
  meta = { };
}
