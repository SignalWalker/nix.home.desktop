{
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./compositor;
  config = {
  };
}

