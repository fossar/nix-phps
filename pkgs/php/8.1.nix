{
  prev,
  mkPhp,
}:

let
  base = mkPhp {
    version = "8.1.34";
    hash = "sha256-mOCgig+uN9CN/MovX/ZmSGMJfd5LHTYK8qzIw1QvKg8=";
  };
in
base.withExtensions (
  {
    all,
    ...
  }:

  with all;
  ([
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
  ])
)
