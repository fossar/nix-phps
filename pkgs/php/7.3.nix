{ prev, mkPhp }:

let
  base = mkPhp {
    version = "7.3.28";
    hash = "sha256-j2NuZEWUOIQ26gX/NMnrE15twRnBEwGZ6UiNV5VDmWQ=";

    extraPatches =
      prev.lib.optionals prev.stdenv.isDarwin [
        # Fix build on Darwin
        # https://bugs.php.net/bug.php?id=76826
        (prev.fetchurl {
          url = "https://github.com/NixOS/nixpkgs/raw/42e9a2ccfab2a96d28c3c164a6cf41fb6f769de5/pkgs/development/interpreters/php/php73-darwin-isfinite.patch";
          sha256 = "V0mLLmXa2qJyxIVW/7nEml6cXZTBbr42kkJiij9KPyk=";
        })
        # Handle macos versions that don't start with 10.* in libtool.
        # https://github.com/php/php-src/commit/d016434ad33284dfaceb8d233351d34356566d7d
        (prev.pkgs.fetchpatch2 {
          url = "https://github.com/php/php-src/commit/d016434ad33284dfaceb8d233351d34356566d7d.patch";
          sha256 = "sha256-x0vEcoXNFeQi3re1TrK/Np9AH5dy3wf95xM08xCyGE0=";
          includes = [
            "build/libtool.m4"
          ];
        })
    ];
  };
in
base.withExtensions (
  { all, ... }:

  with all; (
    [
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
      intl
      json
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
    ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
      imap
    ]
  )
)
