{
  ...
}:
{
  config = {
    services.lspmux = {
      enable = false;
      settings =
        let
          listen = [
            "127.0.0.1"
            59996
          ];
        in
        {
          inherit listen;
          connect = listen;
          pass_environment = [
            "PATH"
            "LD_LIBRARY_PATH"
          ];
        };
    };
  };
  meta = { };
}
