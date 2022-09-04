{ prev, mkPhp }:

let
  base = mkPhp {
    version = "8.2.0rc1";
    hash = null;

    phpAttrsOverrides = attrs: {
      src = prev.fetchurl {
        url = "https://downloads.php.net/~pierrick/php-8.2.0RC1.tar.xz";
        sha256 = "k7s6CzdxZ+GIE+nIKdja8WERYdeIonxQV70jyYRv9ug=";
      };
    };
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

