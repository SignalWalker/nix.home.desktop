{
  ...
}:
{
  config = {
    desktop.windows = [
      {
        name = "godot_float_game_window";
        criteria = {
          initialTitle = "Godot";
          title = ".*DEBUG.*";
        };
        properties = {
          float = true;
        };
      }
      {
        name = "godot_fix_scroll_factor";
        criteria = {
          appId = "org.godotengine.Editor";
        };
        properties = {
          scrollFactor = {
            touchpad = 0.5;
          };
        };
      }
    ];
  };
  meta = { };
}
