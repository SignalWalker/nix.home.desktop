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
          "Super"
        ];
        keysym = "N";
        description = "restore last notification";
      };
      notificationsDismiss = {
        modifiers = [
          "SUPER"
          "ALT"
        ];
        keysym = "N";
        description = "dismiss most recent notification";
      };
      notificationsOpenMenu = {
        modifiers = [
          "SUPER"
          "CTRL"
        ];
        keysym = "N";
        description = "open context menu for most recent notification";
      };
    };
  };
  meta = { };
}
