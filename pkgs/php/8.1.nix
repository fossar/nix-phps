{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.1.0"; hash = ""; }
    { version = "8.1.1"; hash = ""; }
    { version = "8.1.2"; hash = ""; }
    { version = "8.1.3"; hash = ""; }
    { version = "8.1.4"; hash = ""; }
    { version = "8.1.5"; hash = ""; }
    { version = "8.1.6"; hash = ""; }
    { version = "8.1.7"; hash = ""; }
    { version = "8.1.8"; hash = ""; }
    { version = "8.1.9"; hash = ""; }
    { version = "8.1.10"; hash = ""; }
    { version = "8.1.11"; hash = ""; }
    { version = "8.1.12"; hash = ""; }
    { version = "8.1.13"; hash = ""; }
    { version = "8.1.14"; hash = ""; }
    { version = "8.1.15"; hash = ""; }
    { version = "8.1.16"; hash = ""; }
    { version = "8.1.17"; hash = ""; }
    { version = "8.1.18"; hash = ""; }
    { version = "8.1.19"; hash = ""; }
    { version = "8.1.20"; hash = ""; }
    { version = "8.1.21"; hash = ""; }
    { version = "8.1.22"; hash = ""; }
    { version = "8.1.23"; hash = ""; }
  ];

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = prev.php81.override { inherit packageOverrides; version = item.version; hash = item.hash; };
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
