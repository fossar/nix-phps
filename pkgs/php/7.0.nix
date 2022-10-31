{ prev, mkPhp }:

let
  base = mkPhp {
    version = "7.0.33";
    hash = "sha256-STPqdCmKG6BGsCRv43cUFchN+4eDliAbVstTM6vobwc=";
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
