nixpkgs:

# These are older versions of PHP removed from Nixpkgs.

final: prev:

let
  _args = {
    inherit (prev) callPackage lib stdenv nixosTests;

    packageOverrides = self: super: {
      tools = super.tools // {
        php-cs-fixer-2 = self.callPackage ./php-cs-fixer/2.x.nix { };
      };

      extensions = super.extensions // {
        apcu =
          if prev.lib.versionOlder super.php.version "7.0" then
            super.extensions.apcu.overrideAttrs (attrs: {
              name = "apcu-4.0.11";
              version = "4.0.11";
              src = builtins.fetchurl {
                url = "http://pecl.php.net/get/apcu-4.0.11.tgz";
                sha256 = "002d1gklkf0z170wkbhmm2z1p9p5ghhq3q1r9k54fq1sq4p30ks5";
              };
            })
          else
            super.extensions.apcu;

        dom = super.extensions.dom.overrideAttrs (attrs: {
          patches = attrs.patches or [] ++ prev.lib.optionals (prev.lib.versionOlder super.php.version "7.2") [
            # Fix tests with libxml2 2.9.10.
            (prev.fetchpatch {
              url = "https://github.com/php/php-src/commit/e29922f054639a934f3077190729007896ae244c.patch";
              sha256 = "zC2QE6snAhhA7ItXgrc80WlDVczTlZEzgZsD7AS+gtw=";
            })
          ];
        });

        intl = super.extensions.intl.overrideAttrs (attrs: {
          doCheck = if prev.lib.versionOlder super.php.version "7.2" then false else attrs.doCheck or true;
          patches = attrs.patches or [] ++ prev.lib.optionals (prev.lib.versionOlder super.php.version "7.1") [
            # Fix build with newer ICU.
            (prev.fetchpatch {
              url = "https://github.com/php/php-src/commit/8d35a423838eb462cd39ee535c5d003073cc5f22.patch";
              sha256 = if prev.lib.versionOlder super.php.version "7.0" then "8v0k6zaE5w4yCopCVa470TMozAXyK4fQelr+KuVnAv4=" else "NO3EY5z1LFWKor9c/9rJo1rpigG5x8W3Uj5+xAOwm+g=";
              postFetch = ''
                patch "$out" < ${if prev.lib.versionOlder super.php.version "7.0" then ./intl-icu-patch-5.6-compat.patch else ./intl-icu-patch-7.0-compat.patch}
              '';
            })
          ];
        });

        iconv = super.extensions.iconv.overrideAttrs (attrs: {
          patches = attrs.patches or [] ++ prev.lib.optionals (prev.lib.versionOlder super.php.version "8.0") [
            # Header path defaults to FHS location, preventing the configure script from detecting errno support.
            ./iconv-header-path.patch
          ];
        });

        memcached =
          if prev.lib.versionOlder super.php.version "7.0" then
            super.extensions.memcached.overrideAttrs (attrs: {
              name = "memcached-2.2.0";
              version = "2.2.0";
              src = builtins.fetchurl {
                url = "http://pecl.php.net/get/memcached-2.2.0.tgz";
                sha256 = "0n4z2mp4rvrbmxq079zdsrhjxjkmhz6mzi7mlcipz02cdl7n1f8p";
              };
            })
          else
            super.extensions.memcached;

        mysqlnd =
          if prev.lib.versionOlder super.php.version "7.1" then
            super.extensions.mysqlnd.overrideAttrs (attrs: {
              # Fix mysqlnd not being able to find headers.
              postPatch = attrs.postPatch or "" + "\n" + ''
                ln -s $PWD/../../ext/ $PWD
              '';
            })
          else
            super.extensions.mysqlnd;

        oci8 =
          if prev.lib.versionOlder super.php.version "7.0" then
            super.extensions.oci8.override ({
              version = "2.0.12";
              sha256 = "1khqa7fs8dbyjclx05a5ls1f8paw1ij21qwlx3v7p8i3iqhnymkj";
            })
          else
            super.extensions.oci8;

        opcache = super.extensions.opcache.overrideAttrs (attrs: {
          # The patch do not apply to PHP 5’s opcache.
          patches = if prev.lib.versionOlder super.php.version "7.0" then [] else attrs.patches or [];
        });

        openssl =
          if prev.lib.versionOlder super.php.version "7.1" then
            super.extensions.openssl.overrideAttrs (attrs: {
              # PHP ≤ 7.0 requires openssl 1.0.
              buildInputs =
                let
                  openssl_1_0_2 = prev.openssl_1_0_2.overrideAttrs (attrs: {
                    meta = attrs.meta // {
                      # It is insecure but that should not matter in an isolated test environment.
                      knownVulnerabilities = [];
                    };
                  });
                in
                  map (p: if p == prev.openssl then openssl_1_0_2 else p) attrs.buildInputs or [];
              })
          else
            super.extensions.openssl;

        readline = super.extensions.readline.overrideAttrs (attrs: {
          patches = attrs.patches or [] ++ prev.lib.optionals (prev.lib.versionOlder super.php.version "7.2") [
            # Fix readline build
            (prev.fetchpatch {
              url = "https://github.com/php/php-src/commit/1ea58b6e78355437b79fb7b1f287ba6688fb1c57.patch";
              sha256 = "Lh2h07lKkAXpyBGqgLDNXeiOocksARTYIysLWMon694=";
            })
          ];
        });

        zlib = super.extensions.zlib.overrideAttrs (attrs: {
          # The patch does not apply to PHP 7’s zlib.
          patches = if prev.lib.versionOlder super.php.version "7.1" then [] else attrs.patches or [];
        });
      };
    };
  };

  generic = (import "${nixpkgs}/pkgs/development/interpreters/php/generic.nix") _args;

  base56 = prev.callPackage generic (_args // {
    version = "5.6.40";
    sha256 = "/9Al00YjVTqy9/2Psh0Mnm+fow3FZcoDode3YwI/ugA=";
  });

  base70 = prev.callPackage generic (_args // {
    version = "7.0.33";
    sha256 = "STPqdCmKG6BGsCRv43cUFchN+4eDliAbVstTM6vobwc=";
  });

  base71 = prev.callPackage generic (_args // {
    version = "7.1.33";
    sha256 = "laXl8uK3mzdrc3qC2WgskYkeYCifokGDRjoqyhWPT0s=";
  });

  base72 = prev.callPackage generic (_args // {
    version = "7.2.34";
    sha256 = "DlgW1miiuxSspozvjEMEML2Gw8UjP2xCfRpUqsEnq88=";
  });
in {
  php56 = base56.withExtensions ({ all, ... }: with all; ([
    bcmath calendar curl ctype dom exif fileinfo filter ftp gd
    gettext gmp hash iconv intl json ldap mbstring mysqli mysqlnd opcache
    openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
    posix readline session simplexml sockets soap sqlite3
    tokenizer xmlreader xmlwriter zip zlib
  ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [ imap ]));

  php70 = base70.withExtensions ({ all, ... }: with all; ([
    bcmath calendar curl ctype dom exif fileinfo filter ftp gd
    gettext gmp hash iconv intl json ldap mbstring mysqli mysqlnd opcache
    openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
    posix readline session simplexml sockets soap sqlite3
    tokenizer xmlreader xmlwriter zip zlib
  ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [ imap ]));

  php71 = base71.withExtensions ({ all, ... }: with all; ([
    bcmath calendar curl ctype dom exif fileinfo filter ftp gd
    gettext gmp hash iconv intl json ldap mbstring mysqli mysqlnd opcache
    openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
    posix readline session simplexml sockets soap sqlite3
    tokenizer xmlreader xmlwriter zip zlib
  ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [ imap ]));

  php72 = base72.withExtensions ({ all, ... }: with all; ([
    bcmath calendar curl ctype dom exif fileinfo filter ftp gd
    gettext gmp hash iconv intl json ldap mbstring mysqli mysqlnd opcache
    openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
    posix readline session simplexml sockets soap sodium sqlite3
    tokenizer xmlreader xmlwriter zip zlib
  ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [ imap ]));

  php73 = prev.php73.override {
    inherit (_args) packageOverrides;
  };

  php74 = prev.php74.override {
    inherit (_args) packageOverrides;
  };

  php80 = prev.php80.override {
    inherit (_args) packageOverrides;
  };
}
