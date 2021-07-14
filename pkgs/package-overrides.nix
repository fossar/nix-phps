# Nixpkgs packages.
pkgs:

# Overlay to be passed as packageOverrides to Nixpkgs’s generic PHP builder:

final:
prev:

let
  patchName = patch: patch.name or (builtins.baseNameOf patch);
  inherit (pkgs) lib;
in

{
  tools = prev.tools // {
    php-cs-fixer-2 = final.callPackage ./php-cs-fixer/2.x.nix { };
  };

  extensions = prev.extensions // {
    apcu =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.apcu.overrideAttrs (attrs: {
          name = "apcu-4.0.11";
          version = "4.0.11";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/apcu-4.0.11.tgz";
            sha256 = "002d1gklkf0z170wkbhmm2z1p9p5ghhq3q1r9k54fq1sq4p30ks5";
          };
        })
      else
        prev.extensions.apcu;

    dom = prev.extensions.dom.overrideAttrs (attrs: {
      patches =
        let
          upstreamPatches =
            attrs.patches or [];

          ourPatches = lib.optionals (lib.versionOlder prev.php.version "7.2") [
            # Fix tests with libxml2 2.9.10.
            (pkgs.fetchpatch {
              url = "https://github.com/php/php-src/commit/e29922f054639a934f3077190729007896ae244c.patch";
              sha256 = "zC2QE6snAhhA7ItXgrc80WlDVczTlZEzgZsD7AS+gtw=";
            })
          ];
        in
        ourPatches ++ upstreamPatches;

      preCheck =
        lib.pipe
          attrs.preCheck
          [
            (preCheck:
              if lib.versionOlder prev.php.version "7.3" then
                # Test not available on older versions.
                # Introduced in https://github.com/NixOS/nixpkgs/pull/124193
                builtins.replaceStrings [ "rm tests/bug80268.phpt" ] [ "" ] preCheck
              else
                preCheck
            )
          ];
    });

    intl = prev.extensions.intl.overrideAttrs (attrs: {
      doCheck = if lib.versionOlder prev.php.version "7.2" then false else attrs.doCheck or true;
      patches =
        let
          upstreamPatches =
            attrs.patches or [];

          ourPatches =
            lib.optionals (lib.versionOlder prev.php.version "7.1") [
              # Fix build with newer ICU.
              (pkgs.fetchpatch {
                url = "https://github.com/php/php-src/commit/8d35a423838eb462cd39ee535c5d003073cc5f22.patch";
                sha256 = if lib.versionOlder prev.php.version "7.0" then "8v0k6zaE5w4yCopCVa470TMozAXyK4fQelr+KuVnAv4=" else "NO3EY5z1LFWKor9c/9rJo1rpigG5x8W3Uj5+xAOwm+g=";
                postFetch = ''
                  patch "$out" < ${if lib.versionOlder prev.php.version "7.0" then ./intl-icu-patch-5.6-compat.patch else ./intl-icu-patch-7.0-compat.patch}
                '';
              })
            ];
        in
        ourPatches ++ upstreamPatches;
    });

    iconv = prev.extensions.iconv.overrideAttrs (attrs: {
      patches =
        let
          upstreamPatches =
            attrs.patches or [];

          ourPatches =
            lib.optionals (lib.versionOlder prev.php.version "8.0") [
              # Header path defaults to FHS location, preventing the configure script from detecting errno support.
              # TODO: re-add when PHP 7 is removed from Nixpkgs.
              # ./iconv-header-path.patch
            ];
        in
        ourPatches ++ upstreamPatches;
    });

    memcached =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.memcached.overrideAttrs (attrs: {
          name = "memcached-2.2.0";
          version = "2.2.0";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/memcached-2.2.0.tgz";
            sha256 = "0n4z2mp4rvrbmxq079zdsrhjxjkmhz6mzi7mlcipz02cdl7n1f8p";
          };
        })
      else
        prev.extensions.memcached;

    mssql =
      if lib.versionOlder prev.php.version "7.0" then
        prev.mkExtension {
          name = "mssql";
          configureFlags = [
            "--with-mssql=${pkgs.freetds}"
          ];
        }
      else
        null;

    mysql =
      if lib.versionOlder prev.php.version "7.0" then
        prev.mkExtension {
          name = "mysql";
          internalDeps = [ prev.php.extensions.mysqlnd ];
          configureFlags = [
            "--with-mysql"
            "--with-mysql-sock=/run/mysqld/mysqld.sock"
          ];
          # Fix mysql not being able to find headers.
          postPatch = ''
            popd

            ln -s $PWD/../../ext/ $PWD
          '';
        }
      else
        null;

    mysqli =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.mysqli.overrideAttrs (attrs: {
          # the --with-mysql-sock option didn't exist in php 5.6
          NIX_CFLAGS_COMPILE = "-DPHP_MYSQL_UNIX_SOCK_ADDR=\"/run/mysqld/mysqld.sock\"";
        })
      else
        prev.extensions.mysqli;

    mysqlnd =
      if lib.versionOlder prev.php.version "7.1" then
        prev.extensions.mysqlnd.overrideAttrs (attrs: {
          # Fix mysqlnd not being able to find headers.
          postPatch = attrs.postPatch or "" + "\n" + ''
            ln -s $PWD/../../ext/ $PWD
          '';
        })
      else
        prev.extensions.mysqlnd;

    oci8 =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.oci8.override ({
          version = "2.0.12";
          sha256 = "1khqa7fs8dbyjclx05a5ls1f8paw1ij21qwlx3v7p8i3iqhnymkj";
        })
      else
        prev.extensions.oci8;

    opcache = prev.extensions.opcache.overrideAttrs (attrs: {
      patches =
        builtins.filter
          (patch:
            # The patch do not apply to PHP 5’s opcache.
            patchName patch == "zend_file_cache_config.patch" -> lib.versionAtLeast prev.php.version "7.0"
          )
          (attrs.patches or []);
    });

    openssl =
      if lib.versionOlder prev.php.version "7.1" then
        prev.extensions.openssl.overrideAttrs (attrs: {
          # PHP ≤ 7.0 requires openssl 1.0.
          buildInputs =
            let
              openssl_1_0_2 = pkgs.openssl_1_0_2.overrideAttrs (attrs: {
                meta = attrs.meta // {
                  # It is insecure but that should not matter in an isolated test environment.
                  knownVulnerabilities = [];
                };
              });
            in
              map (p: if p == pkgs.openssl then openssl_1_0_2 else p) attrs.buildInputs or [];
          })
      else
        prev.extensions.openssl;

    pdo_mysql =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.pdo_mysql.overrideAttrs (attrs: {
          # PHP_MYSQL_SOCK didn't exist in php 5.6
          NIX_CFLAGS_COMPILE = "-DPDO_MYSQL_UNIX_ADDR=\"/run/mysqld/mysqld.sock\"";
        })
      else
        prev.extensions.pdo_mysql;

    readline = prev.extensions.readline.overrideAttrs (attrs: {
      patches =
        let
          upstreamPatches =
            attrs.patches or [];

          ourPatches =
            lib.optionals (lib.versionOlder prev.php.version "7.2") [
              # Fix readline build
              (pkgs.fetchpatch {
                url = "https://github.com/php/php-src/commit/1ea58b6e78355437b79fb7b1f287ba6688fb1c57.patch";
                sha256 = "Lh2h07lKkAXpyBGqgLDNXeiOocksARTYIysLWMon694=";
              })
            ];
        in
        ourPatches ++ upstreamPatches;
    });

    redis =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.redis.overrideAttrs (attrs: {
          name = "redis-4.3.0";
          version = "4.3.0";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/redis-4.3.0.tgz";
            sha256 = "wPBM7DSZYKhCtgkg+4pDNlbi5JTq7W5mM5fWcQKlG6I=";
          };
        })
      else
        prev.extensions.redis;

    redis3 =
      if lib.versionOlder prev.php.version "8.0" then
        prev.extensions.redis.overrideAttrs (attrs: {
          name = "redis-3.1.6";
          version = "3.1.6";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/redis-3.1.6.tgz";
            sha256 = "siknTNwUwi78Qf76ANtNxbsyqZfWgRJ4ZioEOnaqJgA=";
          };
        })
      else
        throw "php.extensions.redis3 requires PHP version < 8.0.";

    zlib = prev.extensions.zlib.overrideAttrs (attrs: {
      patches =
        builtins.filter
          (patch:
            # The patch does not apply to PHP 7’s zlib.
            patchName patch == "zlib-darwin-tests.patch" -> lib.versionAtLeast prev.php.version "7.1"
          )
          (attrs.patches or []);
    });
  };
}
