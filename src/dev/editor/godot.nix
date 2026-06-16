{
  ...
}:
{
  config = {
    desktop.windows = {
      godotFloatGameWindow = {
        criteria = {
          initialTitle = "Godot";
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
