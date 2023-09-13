{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.3.0RC1"; hash = ""; inherit packageOverrides; }
  ];

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = prev.php83.override item;
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
