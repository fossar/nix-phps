{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.2.0"; hash = ""; }
    { version = "8.2.1"; hash = ""; }
    { version = "8.2.2"; hash = ""; }
    { version = "8.2.3"; hash = ""; }
    { version = "8.2.4"; hash = ""; }
    { version = "8.2.5"; hash = ""; }
    { version = "8.2.6"; hash = ""; }
    { version = "8.2.7"; hash = ""; }
    { version = "8.2.8"; hash = ""; }
    { version = "8.2.9"; hash = ""; }
    { version = "8.2.10"; hash = ""; }
  ];

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = (prev.php83.override { inherit packageOverrides; version = item.version; hash = item.hash; });
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
