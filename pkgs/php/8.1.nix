{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.1.0"; rev = "php-8.1.0"; hash = ""; }
    { version = "8.1.1"; rev = "php-8.1.1"; hash = ""; }
    { version = "8.1.2"; rev = "php-8.1.2"; hash = ""; }
    { version = "8.1.3"; rev = "php-8.1.3"; hash = ""; }
    { version = "8.1.4"; rev = "php-8.1.4"; hash = ""; }
    { version = "8.1.5"; rev = "php-8.1.5"; hash = ""; }
    { version = "8.1.6"; rev = "php-8.1.6"; hash = ""; }
    { version = "8.1.7"; rev = "php-8.1.7"; hash = ""; }
    { version = "8.1.8"; rev = "php-8.1.8"; hash = ""; }
    { version = "8.1.9"; rev = "php-8.1.9"; hash = ""; }
    { version = "8.1.10"; rev = "php-8.1.10"; hash = ""; }
    { version = "8.1.11"; rev = "php-8.1.11"; hash = ""; }
    { version = "8.1.12"; rev = "php-8.1.12"; hash = ""; }
    { version = "8.1.13"; rev = "php-8.1.13"; hash = ""; }
    { version = "8.1.14"; rev = "php-8.1.14"; hash = ""; }
    { version = "8.1.15"; rev = "php-8.1.15"; hash = ""; }
    { version = "8.1.16"; rev = "php-8.1.16"; hash = ""; }
    { version = "8.1.17"; rev = "php-8.1.17"; hash = ""; }
    { version = "8.1.18"; rev = "php-8.1.18"; hash = ""; }
    { version = "8.1.19"; rev = "php-8.1.19"; hash = ""; }
    { version = "8.1.20"; rev = "php-8.1.20"; hash = ""; }
    { version = "8.1.21"; rev = "php-8.1.21"; hash = ""; }
    { version = "8.1.22"; rev = "php-8.1.22"; hash = ""; }
    { version = "8.1.23"; rev = "php-8.1.23"; hash = ""; }
  ];
in
builtins.foldl'
  (acc: item: acc // {
    "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = prev.php81.override { inherit packageOverrides; version = item.version; hash = item.hash; };
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
