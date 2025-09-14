{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  music = config.xdg.userDirs.music;
  wrtag = config.programs.wrtag;
  toFlagConf =
    settings:
    let
      toCfgLine' = key: value: "${key} ${lib.generators.mkValueStringDefault { } value}";
      toCfgLines =
        key: value: if isList value then (map (toCfgLine' key) value) else [ (toCfgLine' key value) ];
    in
    lib.concatLines (
      lib.foldl' (acc: key: acc ++ (toCfgLines key settings.${key})) [ ] (attrNames settings)
    );
in
{
  options = {
    programs.wrtag = {
      enable = lib.mkEnableOption "wrtag";
      package = lib.mkPackageOption pkgs "wrtag" { };
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {
          addon = [
            "replaygain"
            "lyrics musixmatch genius"
          ];
          "path-format" =
            ''${music}/library/{{ artists .Release.Artists | sort | join "; " | safepathUnicode }}/({{ .Release.ReleaseGroup.FirstReleaseDate.Year }}) {{ .Release.Title | safepathUnicode }}{{ if not (eq .ReleaseDisambiguation "") }} ({{ .ReleaseDisambiguation | safepath }}){{ end }}/{{ pad0 2 .TrackNum }}.{{ len .Tracks | pad0 2 }} {{ if .IsCompilation }}{{ artistsString .Track.Artists | safepathUnicode }} - {{ end }}{{ .Track.Title | safepathUnicode }}{{ .Ext }}'';
        };
      };
      extraSettings = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
        default = {
          share = {
            addon = [
              "replaygain"
            ];
            "path-format" =
              ''${music}/share/{{ artists .Release.Artists | sort | join "; " | safepath }} - {{ .Release.ReleaseGroup.FirstReleaseDate.Year }} - {{ .Release.Title | safepath }}/{{ pad0 2 .TrackNum }} {{ .Track.Title | safepath }}{{ .Ext }}'';
          };
        };
      };
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf wrtag.enable {
    home.packages = [
      wrtag.package
      pkgs.transmission_4
    ]
    ++ (lib.optional (lib.any (lib.strings.hasPrefix "replaygain") (
      wrtag.settings.addon or [ ]
    )) pkgs.rsgain);

    xdg.configFile = lib.mkMerge (
      [
        {
          "wrtag/config".text = toFlagConf wrtag.settings;
        }
      ]
      ++ (lib.mapAttrsToList (name: settings: {
        "wrtag/${name}".text = toFlagConf settings;
      }) wrtag.extraSettings)
    );
  };
  meta = { };
}
