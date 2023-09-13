{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.1.0"; hash = ""; inherit packageOverrides; }
    { version = "8.1.1"; hash = ""; inherit packageOverrides; }
    { version = "8.1.2"; hash = ""; inherit packageOverrides; }
    { version = "8.1.3"; hash = ""; inherit packageOverrides; }
    { version = "8.1.4"; hash = ""; inherit packageOverrides; }
    { version = "8.1.5"; hash = ""; inherit packageOverrides; }
    { version = "8.1.6"; hash = ""; inherit packageOverrides; }
    { version = "8.1.7"; hash = ""; inherit packageOverrides; }
    { version = "8.1.8"; hash = ""; inherit packageOverrides; }
    { version = "8.1.9"; hash = ""; inherit packageOverrides; }
    { version = "8.1.10"; hash = ""; inherit packageOverrides; }
    { version = "8.1.11"; hash = ""; inherit packageOverrides; }
    { version = "8.1.12"; hash = ""; inherit packageOverrides; }
    { version = "8.1.13"; hash = ""; inherit packageOverrides; }
    { version = "8.1.14"; hash = ""; inherit packageOverrides; }
    { version = "8.1.15"; hash = ""; inherit packageOverrides; }
    { version = "8.1.16"; hash = ""; inherit packageOverrides; }
    { version = "8.1.17"; hash = ""; inherit packageOverrides; }
    { version = "8.1.18"; hash = ""; inherit packageOverrides; }
    { version = "8.1.19"; hash = ""; inherit packageOverrides; }
    { version = "8.1.20"; hash = ""; inherit packageOverrides; }
    { version = "8.1.21"; hash = ""; inherit packageOverrides; }
    { version = "8.1.22"; hash = ""; inherit packageOverrides; }
    { version = "8.1.23"; hash = ""; inherit packageOverrides; }
  ];

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = prev.php81.override item;
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
