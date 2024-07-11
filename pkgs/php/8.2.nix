{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.2.0"; hash = "sha256-G/T8pmP5PZ4LSQm9bq4Fg6HOOD5/Bd8Sbyjycvof1Ro="; inherit packageOverrides; }
    { version = "8.2.1"; hash = "sha256-ddb482WZPsDR2cYoHUVX5v7sWiYZSkaLiwFFnRd++yk="; inherit packageOverrides; }
    { version = "8.2.2"; hash = "sha256-9SI6UnTtqLQMGeR94N5GeMZdZEAcz3EOJGSWLrgTaAQ="; inherit packageOverrides; }
    { version = "8.2.3"; hash = "sha256-h7tYhl849eKUGBMCkVLOohAv4pYbtNaLiPgx3dBUjQ8="; inherit packageOverrides; }
    { version = "8.2.4"; hash = "sha256-eRhvlL1RDbhuMeU13USCd6Hrkqh4eDA6Hq1EYC2LEZc="; inherit packageOverrides; }
    { version = "8.2.5"; hash = "sha256-5agGY8yk9gRK2GpIl5gUfHrwN+ypb2zTV6s20oy2N1c="; inherit packageOverrides; }
    { version = "8.2.6"; hash = "sha256-RKcMUvU3ZiwQ2R7tv1H9dlyZYb5rolCO1jv3omzdMQA="; inherit packageOverrides; }
    { version = "8.2.7"; hash = "sha256-W/sqNcZ5Ib3K3VyQyykK11N9JNoROl6LwtZGsC3nSI8="; inherit packageOverrides; }
    { version = "8.2.8"; hash = "sha256-mV7UAJx5F8li0xg3oaNljzbUr081e2c8l//b5kA/hRc="; inherit packageOverrides; }
    { version = "8.2.9"; hash = "sha256-SEYLmUrn61CWoxD0TRPoZd4XcRBNSlUNUwcr5YpvF2w="; inherit packageOverrides; }
    { version = "8.2.10"; hash = "sha256-zJg06PG2E9dneviEPDZR6YKavKjr/pB5JR0Nhdmgqj4="; inherit packageOverrides; }
  ];

  makeSrc = item: {
    src = prev.fetchurl {
      url = "https://www.php.net/distributions/php-${item.version}.tar.bz2";
      inherit (item) hash;
    };
  };

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = prev.php82.override { inherit packageOverrides; phpAttrsOverrides = attrs: ((builtins.removeAttrs item [ "packageOverrides" ]) // makeSrc item); };
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
