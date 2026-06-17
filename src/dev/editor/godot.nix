{
  ...
}:
{
  config = {
    desktop.windows = {
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
