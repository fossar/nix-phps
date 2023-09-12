{ prev, mkPhp, ... }:

let
  archives = [
    { version = "8.0.0"; rev = "php-8.0.0"; hash = "sha256-XoMtw36r9ERBC06m+z1mty5E50B6O0nKpXRu3PcbnQk="; }
    { version = "8.0.1"; rev = "php-8.0.1"; hash = "sha256-xE52r0DRM95kVk+cr12uxSu+hMHMtORQCmIjPWFOve4="; }
    { version = "8.0.2"; rev = "php-8.0.2"; hash = "sha256-AA+onj6uMXwLF+4EginNaKOKOw/vcsVYaB/QBAV7o+Y="; }
    { version = "8.0.3"; rev = "php-8.0.3"; hash = "sha256-lfhiHZ40+CLSWDVkw1hZjf9zRiQfg5v6MZu/Zb8usBI="; }
    { version = "8.0.4"; rev = "php-8.0.4"; hash = ""; }
    { version = "8.0.5"; rev = "php-8.0.5"; hash = "sha256-GV2TT+vvqsOxmsWGZ5FJdZMkpDRBGuispvfYdVPvCOA="; }
    { version = "8.0.6"; rev = "php-8.0.6"; hash = "sha256-Jqip2tZgEgOd6wvPFRxuIqseS2qRUIOD/3BdpBKJUm4="; }
    { version = "8.0.7"; rev = "php-8.0.7"; hash = "sha256-crLyyW81dIsdbopxr06tQ5sXEprv5hHrC68b0xNjX3k="; }
    { version = "8.0.8"; rev = "php-8.0.8"; hash = "sha256-FL131xqYlD4UsyTag+MbVyeB31g82pZQoYT64yFM0W8="; }
    { version = "8.0.9"; rev = "php-8.0.9"; hash = "sha256-asjt69KV3cQ/sBBlPEPM8gPNfNxAmBshDtUnWZQECAY="; }
    { version = "8.0.10"; rev = "php-8.0.10"; hash = "sha256-yUVHJxQQkAhFsITsK8s0Zq82PuypLLJL1hHcvcJvFYc="; }
    { version = "8.0.11"; rev = "php-8.0.11"; hash = "sha256-cO2HQoXkAQweLok3v7VrE7ntGzeJ3K8nS3k7AMH0QDo="; }
    { version = "8.0.12"; rev = "php-8.0.12"; hash = "sha256-tIhtsd8yLcj7Eo2LNK5+lPb8aC7LKf9PWlkdTen+rb8="; }
    { version = "8.0.13"; rev = "php-8.0.13"; hash = "sha256-wkGde6Q5X0R0cEP05vW0f6CBJXBfufiDd+RTBoqBWDY="; }
    { version = "8.0.14"; rev = "php-8.0.14"; hash = "sha256-uzgf30gXrXwkwj6n93ytaNzrhus6waN6ztrfitCgzUs="; }
    { version = "8.0.15"; rev = "php-8.0.15"; hash = "sha256-iBFxyQq6dG0o33aPPZn6MmGZnlBkFb5Mc1IHimT+Wdw="; }
    { version = "8.0.16"; rev = "php-8.0.16"; hash = "sha256-9J+Bge4pRjoNI6DGWWnpLVj+6KxWTfkXz/WOSNZeGEk="; }
    { version = "8.0.17"; rev = "php-8.0.17"; hash = "sha256-UoEe4t3nFmDKMnN6SsaWwkWR6yLoRt2OCe53EiZgKD8="; }
    { version = "8.0.18"; rev = "php-8.0.18"; hash = "sha256-gm7jSIGhw0lnjU98xV/5FB+hQRNE5LuPldD5IjvOtVo="; }
    { version = "8.0.19"; rev = "php-8.0.19"; hash = "sha256-66Dmf9r2kEsuS4TgZL4KDWGyy2SiP4GgypsaUbw6gzA="; }
    { version = "8.0.20"; rev = "php-8.0.20"; hash = "sha256-y3Zmv2ftn2yYfUg2yvA9SzZFN+anXlbNXJhnYOzC/dg="; }
    { version = "8.0.21"; rev = "php-8.0.21"; hash = "sha256-HLd2LR/+zOruuvufbiQTLKI/sUQ8tWMND8z1PwTPoSY="; }
    { version = "8.0.22"; rev = "php-8.0.22"; hash = "sha256-40KRjT7NQi8QAy3wrD/7Dhf1aPrWz44jK296ah/cPJw="; }
    { version = "8.0.23"; rev = "php-8.0.23"; hash = "sha256-FBLbRoAKRc7Td8KJLsYmGzxBLxPcEzv8mYz7LxR7QM8="; }
    { version = "8.0.24"; rev = "php-8.0.24"; hash = "sha256-kI4XzqMx1au4UGtKicY5K5YuEnw5Eyd3fHSF60tBXUM="; }
    { version = "8.0.25"; rev = "php-8.0.25"; hash = "sha256-CdcWvOtbPbdtkCOxDBaB674EDlH0wY39Nfn/i3O7z4w="; }
    { version = "8.0.26"; rev = "php-8.0.26"; hash = "sha256-bfh6+W8nWnWIns5uP+ShOr2Tp2epmShjvcDpDx6Ifuc="; }
    { version = "8.0.27"; rev = "php-8.0.27"; hash = "sha256-X9iCsUN3wVjBtVzGrOkfuMGbd8WW1YMa0ST7u8kC28g="; }
    { version = "8.0.28"; rev = "php-8.0.28"; hash = "sha256-nV50k1yQDjuce2vHQFlrcZM2MOufY3F8DEkj2MeIxi4="; }
    { version = "8.0.29"; rev = "php-8.0.29"; hash = "sha256-SAGh8OFxcChnI6tUrNBFrHipZWAh1W8QSmRUPuySLhI="; }
    { version = "8.0.30"; rev = "php-8.0.30"; hash = "sha256-mKnLag4nppUM30sm3KxI8r4tk21SJKUC8GbPPUzxm5I="; }
  ];
in
builtins.foldl'
  (acc: item: acc // {
    "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = (mkPhp { version = item.version; hash = item.hash; }).withExtensions
      (
        { all, ... }: with all; [
          bcmath
          calendar
          curl
          ctype
          dom
          exif
          fileinfo
          filter
          ftp
          gd
          gettext
          gmp
          iconv
          imap
          intl
          ldap
          mbstring
          mysqli
          mysqlnd
          opcache
          openssl
          pcntl
          pdo
          pdo_mysql
          pdo_odbc
          pdo_pgsql
          pdo_sqlite
          pgsql
          posix
          readline
          session
          simplexml
          sockets
          soap
          sodium
          sysvsem
          sqlite3
          tokenizer
          xmlreader
          xmlwriter
          zip
          zlib
        ]
      );
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
