{
  pkgs,
  ...
}:
{
  config = {
    home.packages = [ pkgs.zotero ];
    desktop.scratchpads = {
      "Shift+Z" = {
        criteria = {
          # class = "Zotero";
          # instance = "Navigator";
          app_id = "Zotero";
        };
        hypr = {
          match_by = "class";
          process_tracking = false;
        };
        resize = 93;
        name = "zotero";
        startup = "zotero";
        autostart = true;
        automove = true;
      };
    };
  };
  meta = { };
}
