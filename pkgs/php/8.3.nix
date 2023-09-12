{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.2.0"; rev = "php-8.2.0"; hash = ""; }
    { version = "8.2.1"; rev = "php-8.2.1"; hash = ""; }
    { version = "8.2.2"; rev = "php-8.2.2"; hash = ""; }
    { version = "8.2.3"; rev = "php-8.2.3"; hash = ""; }
    { version = "8.2.4"; rev = "php-8.2.4"; hash = ""; }
    { version = "8.2.5"; rev = "php-8.2.5"; hash = ""; }
    { version = "8.2.6"; rev = "php-8.2.6"; hash = ""; }
    { version = "8.2.7"; rev = "php-8.2.7"; hash = ""; }
    { version = "8.2.8"; rev = "php-8.2.8"; hash = ""; }
    { version = "8.2.9"; rev = "php-8.2.9"; hash = ""; }
    { version = "8.2.10"; rev = "php-8.2.10"; hash = ""; }
  ];
in
builtins.foldl'
  (acc: item: acc // {
    "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = (prev.php82.override { inherit packageOverrides; version = item.version; hash = item.hash; });
  })
  { }
  (
    archives ++ [
      (
        let last = (prev.lib.last archives); in {
          version = prev.lib.versions.majorMinor last.version;
          rev = last.rev;
          hash = last.hash;
        }
      )
    ]
  )
