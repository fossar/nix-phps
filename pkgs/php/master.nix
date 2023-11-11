{ prev
, generic
, _mkArgs
, php-src
}:

let
  pear = prev.fetchurl {
    url = "https://pear.php.net/install-pear-nozlib.phar";
    hash = "sha256-UblKVcsm030tNSA6mdeab+h7ZhANNz7MkFf4Z1iigjs=";
  };

  base-master = prev.callPackage generic (_mkArgs {
    hash = null;

    version =
      let
        configureFile = "${php-src}/configure.ac";

        extractVersionFromConfigureAc = configureText:
          let
            match = builtins.match ".*AC_INIT\\(\\[PHP],\\[([^]-]+)(-dev)?].*" configureText;
          in
          if match != null then builtins.head match else null;

        extractVersionFromConfigureAcPre74 = configureText:
          let
            match = builtins.match ".*PHP_MAJOR_VERSION=([0-9]+)\nPHP_MINOR_VERSION=([0-9]+)\nPHP_RELEASE_VERSION=([0-9]+)\n.*" configureText;
          in
          if match != null then prev.lib.concatMapStringsSep "." builtins.toString match else null;

        version =
          let
            configureText = builtins.readFile configureFile;
            version = extractVersionFromConfigureAc configureText;
            versionPre74 = extractVersionFromConfigureAcPre74 configureText;

            versionCandidates = prev.lib.optionals (builtins.pathExists configureFile) [
              version
              versionPre74
            ];
          in
          prev.lib.findFirst (version: version != null) "0.0.0+unknown" versionCandidates;
      in
      "${version}.snapshot.${php-src.shortRev}-${php-src.lastModifiedDate}";

    phpAttrsOverrides = attrs: {
      src = php-src;

      preInstall = attrs.preInstall or "" + ''
        cp -f ${pear} ./pear/install-pear-nozlib.phar
      '';
    };
  });
in
base-master.withExtensions ({ all, ... }: with all; [
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
])
