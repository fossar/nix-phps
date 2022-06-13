{ prev, mkPhp }:

let
  base = mkPhp {
    version = "7.3.28";
    sha256 = "0r4r8famg3a8x6ch24y1370nsphkxg4k9zq5x8v88f4l8mj6wqwg";

    extraPatches =
      prev.lib.optionals prev.stdenv.isDarwin [
        # Fix build on Darwin
        # https://bugs.php.net/bug.php?id=76826
        (prev.fetchurl {
          url = "https://github.com/NixOS/nixpkgs/raw/42e9a2ccfab2a96d28c3c164a6cf41fb6f769de5/pkgs/development/interpreters/php/php73-darwin-isfinite.patch";
          sha256 = "V0mLLmXa2qJyxIVW/7nEml6cXZTBbr42kkJiij9KPyk=";
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
