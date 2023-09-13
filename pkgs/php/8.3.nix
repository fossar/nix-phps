{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.2.0"; hash = ""; inherit packageOverrides; }
    { version = "8.2.1"; hash = ""; inherit packageOverrides; }
    { version = "8.2.2"; hash = ""; inherit packageOverrides; }
    { version = "8.2.3"; hash = ""; inherit packageOverrides; }
    { version = "8.2.4"; hash = ""; inherit packageOverrides; }
    { version = "8.2.5"; hash = ""; inherit packageOverrides; }
    { version = "8.2.6"; hash = ""; inherit packageOverrides; }
    { version = "8.2.7"; hash = ""; inherit packageOverrides; }
    { version = "8.2.8"; hash = ""; inherit packageOverrides; }
    { version = "8.2.9"; hash = ""; inherit packageOverrides; }
    { version = "8.2.10"; hash = ""; inherit packageOverrides; }
  ];

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = prev.php83.override item;
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
