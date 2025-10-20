{
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./notifications;
  config = {
    desktop.keybinds = {
      notificationsRestore = {
        modifiers = [
          "MOD3"
        ];
        keysym = "N";
        description = "restore last notification";
      };
      notificationsDismiss = {
        modifiers = [
          "MOD3"
          "ALT"
        ];
        keysym = "N";
        description = "dismiss most recent notification";
      };
      notificationsOpenMenu = {
        modifiers = [
          "MOD3"
          "CTRL"
        ];
        keysym = "N";
        description = "open context menu for most recent notification";
      };
    };
  };
  meta = { };
}
