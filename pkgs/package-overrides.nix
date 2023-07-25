# Nixpkgs packages.
pkgs:

# Overlay to be passed as packageOverrides to Nixpkgs’s generic PHP builder:

final:
prev:

let
  patchName = patch: patch.name or (builtins.baseNameOf patch);

  linkInternalDeps = extensions: ''
    ${lib.concatMapStringsSep
      "\n"
      (dep: "mkdir -p ext; ln -s ${dep.dev}/include ext/${dep.extensionName}")
      extensions
    }
  '';

  inherit (pkgs) lib;

  inherit (import ./lib.nix { inherit lib; }) removeLines;
in

{
  buildPecl =
    {
      internalDeps ? [],
      ...
    }@args:

    prev.buildPecl (args // {
      # We started bundling hash so we need to remove
      # references to the external extension which no longer exists.
      internalDeps = builtins.filter (d: d != null) internalDeps;
    });

  tools = prev.tools // {
    php-cs-fixer-2 = final.callPackage ./php-cs-fixer/2.x.nix { };
    composer-1 = final.callPackage ./composer/1.x.nix { };
  } // lib.optionalAttrs (lib.versionOlder prev.php.version "7.2.5") {
    composer = final.callPackage ./composer/2.2.nix { };
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

    ast =
      if lib.versionOlder prev.php.version "7.2" then
        prev.extensions.ast.overrideAttrs (attrs: {
          name = "ast-1.0.16";
          version = "1.0.16";
          src = pkgs.fetchFromGitHub {
            owner = "nikic";
            repo = "php-ast";
            rev = "v1.0.16";
            hash = "sha256-PQLwKsVkNpa41jg+dZC/SO7tQ7bkywA9/LRsD5t6FlY=";
          };
        })
      else
        prev.extensions.ast;

    blackfire =
      if lib.versionAtLeast prev.php.version "8.3" then
        throw "php.extensions.blackfire requires PHP version >= 5.6 and < 8.3"
      else if lib.versionAtLeast prev.php.version "8.1" then
        prev.extensions.blackfire
      else if lib.versionAtLeast prev.php.version "7.0" then
        final.callPackage ./extensions/blackfire/1.88.1.nix { inherit prev; }
      else
        final.callPackage ./extensions/blackfire/1.50.0.nix { inherit prev; };

    couchbase = prev.extensions.couchbase.overrideAttrs (attrs: {
      preConfigure =
        let
          deps = lib.optionals (lib.versionOlder prev.php.version "8.0") [
            final.extensions.json
          ];
        in
        attrs.preConfigure or "" + linkInternalDeps deps;
    });

    datadog_trace =
      if lib.versionAtLeast prev.php.version "8.3" then
        throw "php.extensions.datadog_trace requires PHP version >= 5.6 and < 8.3"
      else if lib.versionOlder prev.php.version "7" then
        final.callPackage ./extensions/datadog_trace/0.75.0.nix { }
      else
        prev.extensions.datadog_trace;

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
          ] ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
            (pkgs.fetchpatch {
              url = "https://github.com/php/php-src/commit/4cc261aa6afca2190b1b74de39c3caa462ec6f0b.patch";
              sha256 = "11qsdiwj1zmpfc2pgh6nr0sn7qa1nyjg4jwf69cgwnd57qfjcy4k";
              excludes = [
                "ext/dom/tests/bug43364.phpt"
                "ext/dom/tests/bug80268.phpt"
              ];
            })
          ];
        in
        ourPatches ++ upstreamPatches;

      configureFlags =
        attrs.configureFlags or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Required to build on darwin.
          "--with-libxml-dir=${pkgs.libxml2.dev}"
        ];

      postPatch =
        lib.concatStringsSep "\n" [
          (attrs.postPatch or "")

          (lib.optionalString (lib.versionOlder prev.php.version "7.4" && lib.versionAtLeast prev.php.version "7.3") ''
            # 4cc261aa6afca2190b1b74de39c3caa462ec6f0b deletes this file but fetchpatch does not support deletions.
            rm ext/dom/tests/bug80268.phpt
          '')

          (lib.optionalString (lib.versionOlder prev.php.version "7.4") ''
            # 4cc261aa6afca2190b1b74de39c3caa462ec6f0b deletes this file but fetchpatch does not support deletions.
            rm ext/dom/tests/bug43364.phpt
          '')

          (lib.optionalString (lib.versionOlder prev.php.version "8.1" && lib.versionAtLeast prev.php.version "7.1") ''
            # Removing tests failing with libxml2 (2.11.4) > 2.10.4
            rm ext/dom/tests/DOMDocument_loadXML_error2.phpt
            rm ext/dom/tests/DOMDocument_load_error2.phpt
          '')
        ];
    });

    ds =
      if lib.versionOlder prev.php.version "7.0" then
        throw "php.extensions.ds requires PHP version >= 7.0"
      else
        prev.extensions.ds.overrideAttrs (attrs: {
          preConfigure =
            let
              deps = lib.optionals (lib.versionOlder prev.php.version "8.0") [
                final.extensions.json
              ];
            in
            attrs.preConfigure or "" + linkInternalDeps deps;
        });

    enchant = let
      enchant1 = pkgs.callPackage ./enchant/1.x.nix { };
    in
    prev.extensions.enchant.overrideAttrs (attrs: {
      buildInputs = attrs.buildInputs or [] ++
        lib.optionals (lib.versionOlder prev.php.version "8.0") [
          enchant1
        ];

      configureFlags = attrs.configureFlags or [] ++
        lib.optionals (lib.versionOlder prev.php.version "8.0") [
          "--with-enchant=${lib.getDev enchant1}"
        ];
    });

    ffi =
      if lib.versionAtLeast prev.php.version "7.4" then
        prev.extensions.ffi
      else
        throw "php.extensions.ffi requires PHP version >= 7.4.";

    gd =
      if lib.versionOlder prev.php.version "7.4" then
        prev.mkExtension {
          name = "gd";

          buildInputs = [
            pkgs.gd
            pkgs.xorg.libXpm
            # Older versions of PHP check for these libraries even when not using bundled gd.
            pkgs.zlib
            pkgs.libjpeg
            pkgs.libpng
          ];

          configureFlags = [
            "--with-gd=${pkgs.gd.dev}"
            "--with-freetype-dir=${pkgs.freetype.dev}"
            "--with-jpeg-dir=${pkgs.libjpeg.dev}"
            "--with-png-dir=${pkgs.libpng.dev}"
            "--with-webp-dir=${pkgs.libwebp}"
            "--with-xpm-dir=${pkgs.xorg.libXpm.dev}"
            "--with-zlib-dir=${pkgs.zlib.dev}"
            "--enable-gd-jis-conv"
          ];

          doCheck = false;
        }
      else
        prev.extensions.gd;

    gettext = prev.extensions.gettext.overrideAttrs (attrs: {
      patches =
        attrs.patches or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Fix darwin build
          # Introduced in https://github.com/NixOS/nixpkgs/commit/af064a0e12ad8e5a8a2e8d8ad25fc0baf3f8ef54
          (pkgs.fetchpatch {
            url = "https://github.com/php/php-src/commit/632b6e7aac207194adc3d0b41615bfb610757f41.patch";
            sha256 = "0xn3ivhc4p070vbk5yx0mzj2n7p04drz3f98i77amr51w0vzv046";
          })
        ];
    });

    grpc =
      if lib.versionOlder prev.php.version "7.0" then
        throw "php.extensions.grpc requires PHP version >= 7.0"
      else
        prev.extensions.grpc;

    igbinary =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.igbinary.overrideAttrs (attrs: {
          name = "igbinary-2.0.8";
          version = "2.0.8";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/igbinary-2.0.8.tgz";
            hash = "sha256-usurEXLgc7GFfcB6SGv9rKbWD77WeM4PSzfNAY71toA=";
          };
        })
      else
        prev.extensions.igbinary;

    inotify =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.inotify.overrideAttrs (attrs: {
          name = "inotify-0.1.6";
          version = "0.1.6";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/inotify-0.1.6.tgz";
            hash = "sha256-l5+Aol1OsN4oJhf/wN9G8HNGqDg/MQublD5ImS5bSU4=";
          };
        })
      else
        prev.extensions.inotify;

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
                  # Resolve conflicts of the upstream patch with the old PHP source tree.
                  patch "$out" < ${if lib.versionOlder prev.php.version "7.0" then ./patches/intl-icu-patch-5.6-compat.patch else ./patches/intl-icu-patch-7.0-compat.patch}
                '';
              })
            ]
            ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
              # Fix aarch64 build
              # Introduced in https://github.com/NixOS/nixpkgs/commit/30e812c6c09e1b971dc902399f3dc39d542d89d9
              (pkgs.fetchpatch {
                url = "https://github.com/php/php-src/commit/93a9b56c90c334896e977721bfb3f38b1721cec6.patch";
                sha256 = "055l40lpyhb0rbjn6y23qkzdhvpp7inbnn6x13cpn4inmhjqfpg4";
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
              ./patches/iconv-header-path.patch
            ];
        in
        ourPatches ++ upstreamPatches;
    });

    json =
      if lib.versionAtLeast prev.php.version "8.0" then
        throw "php.extensions.json is enabled by default in PHP >= 8.0."
      else
        prev.mkExtension {
          name = "json";
        };

    mailparse =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.mailparse.overrideAttrs (attrs: {
          name = "mailparse-2.1.6";
          version = "2.1.6";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/mailparse-2.1.6.tgz";
            hash = "sha256-c3BRl9Ky7ngu+lR36yohQy9ZLCywWnLDoDe7454Ctcw=";
          };
        })
      else if lib.versionOlder prev.php.version "7.3" then
        prev.extensions.mailparse.overrideAttrs (attrs: {
          name = "mailparse-3.1.3";
          version = "3.1.3";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/mailparse-3.1.3.tgz";
            hash = "sha256-hlnKYtyaTX0V8H+XoOIULLWCUcjncs02Zp7HQNIpJHE=";
          };
        })
      else
        prev.extensions.mailparse;

    maxminddb =
      if lib.versionOlder prev.php.version "7.2" then
        throw "php.extensions.maxminddb requires PHP >= 7.2."
      else
        prev.extensions.maxminddb;

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

    mongodb =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.mongodb.overrideAttrs (attrs: {
          name = "mongodb-1.7.5";
          version = "1.7.5";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/mongodb-1.7.5.tgz";
            hash = "sha256-5IoHYYwK6L5igpmZG19IGGHIkaIlRKI2WmM2HMGBw3k=";
          };
        })
      else if lib.versionOlder prev.php.version "7.1" then
        prev.extensions.mongodb.overrideAttrs (attrs: {
          name = "mongodb-1.9.2";
          version = "1.9.2";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/mongodb-1.9.2.tgz";
            hash = "sha256-legyxdSK5ulHvcefNan48LvVGPSqAPHO9snq+64CGH0=";
          };
        })
      else if lib.versionOlder prev.php.version "7.2" then
        prev.extensions.mongodb.overrideAttrs (attrs: {
          name = "mongodb-1.11.1";
          version = "1.11.1";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/mongodb-1.11.1.tgz";
            hash = "sha256-g4pQUN5Q1R+VkCa9jOxzSdivNwWMD+BylaC8lgqC1+8=";
          };
        })
      else
        prev.extensions.mongodb;

    msgpack =
      if lib.versionOlder prev.php.version "7.0" then
        throw "php.extensions.msgpack requires PHP version >= 7.0"
      else
        prev.extensions.msgpack;

    mssql =
      if lib.versionOlder prev.php.version "7.0" then
        prev.mkExtension {
          name = "mssql";
          configureFlags = [
            "--with-mssql=${pkgs.freetds}"
          ];
          patches = [
            # Make sure it looks also for the proper extension files
            ./patches/0001-mssql-extension-fix-builds-on-darwin.patch
          ];
        }
      else
        throw "php.extensions.mssql requires PHP version < 7.0.";

    mysql =
      if lib.versionOlder prev.php.version "7.0" then
        prev.mkExtension {
          name = "mysql";
          internalDeps = [ final.extensions.mysqlnd ];
          configureFlags = [
            "--with-mysql"
            "--with-mysql-sock=/run/mysqld/mysqld.sock"
          ];
          postPatch = ''
            # Fix mysql not being able to find headers.
            ln -s $PWD/ext/ ext/mysql
          '';
        }
      else
        throw "php.extensions.mysql requires PHP version < 7.0.";

    mysqli =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.mysqli.overrideAttrs (attrs: {
          # the --with-mysql-sock option didn't exist in php 5.6
          NIX_CFLAGS_COMPILE = "-DPHP_MYSQL_UNIX_SOCK_ADDR=\"/run/mysqld/mysqld.sock\"";
        })
      else
        prev.extensions.mysqli;

    mysqlnd = prev.extensions.mysqlnd.overrideAttrs (attrs: {
      patches =
        attrs.patches or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Introduced in https://github.com/NixOS/nixpkgs/commit/2e0d4a8b39a03a0db0c6c3622473d333a44d1ec1
          ./patches/mysqlnd_fix_compression.patch
        ];

      postPatch =
        attrs.postPatch or ""
        + lib.optionalString (lib.versionOlder prev.php.version "7.1") ''
          # Fix mysqlnd not being able to find headers.
          ln -s $PWD/ext/ ext/mysqlnd
        '';

      preConfigure =
        attrs.preConfigure or ""
        + lib.optionalString (lib.versionOlder prev.php.version "7.4") ''
          substituteInPlace configure \
            --replace '$OPENSSL_LIBDIR' '${pkgs.openssl}/lib' \
            --replace '$OPENSSL_INCDIR' '${pkgs.openssl.dev}/include'
        '';
    });

    oci8 =
      if lib.versionOlder prev.php.version "7.0" then
        prev.extensions.oci8.overrideAttrs (attrs: {
          name = "oci8-2.0.12";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/oci8-2.0.12.tgz";
            sha256 = "1khqa7fs8dbyjclx05a5ls1f8paw1ij21qwlx3v7p8i3iqhnymkj";
          };
        })
      else if lib.versionOlder prev.php.version "8.0" then
        prev.extensions.oci8.overrideAttrs (attrs: {
          name = "oci8-2.2.0";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/oci8-2.2.0.tgz";
            sha256 = "0jhivxj1nkkza4h23z33y7xhffii60d7dr51h1czjk10qywl7pyd";
          };
        })
      else
        prev.extensions.oci8;

    opcache = prev.extensions.opcache.overrideAttrs (attrs: {
      patches =
        attrs.patches or []
        ++ lib.optionals (lib.versionAtLeast prev.php.version "7.0" && lib.versionOlder prev.php.version "7.4") [
          # Introduced in https://github.com/NixOS/nixpkgs/commit/2e0d4a8b39a03a0db0c6c3622473d333a44d1ec1
          ./patches/zend_file_cache_config.patch
        ];

      doCheck = lib.versionAtLeast prev.php.version "7.4";

      postPatch =
        removeLines
          (lib.optionals (lib.versionOlder prev.php.version "7.2.20" && pkgs.stdenv.isDarwin) [
            "rm ext/opcache/tests/bug78106.phpt"
          ])
          attrs.postPatch;
    });

    openssl = prev.extensions.openssl.overrideAttrs (attrs: {
      patches =
        let
          upstreamPatches =
            attrs.patches or [];

          ourPatches =
            lib.optionals (lib.versionOlder prev.php.version "7.0") [
              # PHP ≤ 5.6 requires openssl 1.0.
              # https://github.com/php-build/php-build/pull/609
              # https://github.com/oerdnj/deb.sury.org/issues/566
              (pkgs.fetchurl {
                url = "https://github.com/php-build/php-build/raw/43c8e02689bc29d48daa338b73bcd4f2bbd8def1/share/php-build/patches/php-5.6-support-openssl-1.1.0.patch";
                sha256 = "UHu3SyYSMozfXlm5ZGRaSdD5NnrdAB7NaY4P0NREVCE=";
              })
            ];
        in
        ourPatches ++ upstreamPatches;

      buildInputs =
        let
          replaceOpenssl = pkg:
            if pkg.pname == "openssl" && lib.versionOlder prev.php.version "8.1" then
              pkgs.openssl_1_1.overrideAttrs (old: {
                meta = builtins.removeAttrs old.meta [ "knownVulnerabilities" ];
              })
            else
              pkg;
        in
        builtins.map replaceOpenssl attrs.buildInputs;
    });

    openswoole =
      if lib.versionOlder prev.php.version "7.2" then
        throw "php.extensions.openswoole requires PHP version >= 7.2."
      else if lib.versionOlder prev.php.version "7.4" then
        prev.extensions.openswoole.overrideAttrs (attrs: {
          name = "openswoole-4.10.0";
          version = "4.10.0";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/openswoole-4.10.0.tgz";
            hash = "sha256-FSJUcL3gJaaq4ruUK6AbKeUYVvkBj4gJPZkvTrG6Dm8=";
          };
        })
      else
        prev.extensions.openswoole;

    pcov = if lib.versionAtLeast prev.php.version "7.1" then
        prev.extensions.pcov
      else
        throw "php.extensions.pcov requires PHP version >= 7.1.";

    pdlib = if lib.versionOlder prev.php.version "7.0" then
        throw "php.extensions.pdlib requires PHP version >= 7.0."
      else
        prev.extensions.pdlib;

    pdo = prev.extensions.pdo.overrideAttrs (attrs: {
      patches =
        let
          upstreamPatches =
            attrs.patches or [];

          ourPatches =
            lib.optionals (lib.versionOlder prev.php.version "7.2") [
              # Fix Darwin builds on 7.1
              (pkgs.fetchpatch {
                url = "https://github.com/php/php-src/commit/11eed9f3ba7429be467b54d8407cfbd6bd7e6f3a.patch";
                sha256 = "1mvdsc3kc1fb2l3fh6hva20gyay1214zqj24mavp7x6g0ngii06l";
              })
            ];
        in
        ourPatches ++ upstreamPatches;
    });

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
      else if lib.versionOlder prev.php.version "8.0" then
        prev.extensions.redis.overrideAttrs (attrs: {
          preConfigure =
            let
              deps = lib.optionals (lib.versionOlder prev.php.version "8.0") [
                final.extensions.json
              ];
            in
            attrs.preConfigure or "" + linkInternalDeps deps;
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
            hash = "sha256-siknTNwUwi78Qf76ANtNxbsyqZfWgRJ4ZioEOnaqJgA=";
          };
          meta = attrs.meta // {
            platforms = lib.platforms.linux;
          };
        })
      else
        throw "php.extensions.redis requires PHP version < 8.0.";

    relay =
      if lib.versionAtLeast prev.php.version "8.0" then
        prev.extensions.relay
      else
        throw "php.extensions.relay requires PHP version >= 8.0.";

    simplexml = prev.extensions.simplexml.overrideAttrs (attrs: {
      configureFlags =
        attrs.configureFlags or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Required to build on darwin.
          "--with-libxml-dir=${pkgs.libxml2.dev}"
        ];
      });

    swoole =
      if lib.versionAtLeast prev.php.version "8.0" then
        prev.extensions.swoole
      else if lib.versionAtLeast prev.php.version "7.2" then
        prev.extensions.swoole.overrideAttrs (attrs: {
          name = "swoole-4.8.13";
          version = "4.8.13";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/swoole-4.8.13.tgz";
            hash = "sha256-9Le4VsESsQWJheCx/KMg7BIRKZYHs2MHPemnCWKK0yo=";
          };
        })
      else
        throw "php.extensions.swoole requires PHP version >= 7.2.";

    soap = prev.extensions.soap.overrideAttrs (attrs: {
      configureFlags =
        attrs.configureFlags or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Required to build on darwin.
          "--with-libxml-dir=${pkgs.libxml2.dev}"
        ];
      });

    tidy = prev.extensions.tidy.overrideAttrs (attrs: {
      patches =
        let
          upstreamPatches =
            attrs.patches or [];

          ourPatches =
            lib.optionals (lib.versionOlder prev.php.version "7.1") [
              # Add support for the new tidy-html5 library.
              # https://github.com/php/php-src/commit/a552ac5bd589035b66c899b74511b29a3d1a4718
              (pkgs.fetchpatch {
                url = "https://github.com/php/php-src/commit/a552ac5bd589035b66c899b74511b29a3d1a4718.patch";
                sha256 = "bXDgtCYwxZ9sQLNh3RR1W+g8JWn0ottRhK5LNTtDBVA=";
              })
            ];
        in
        ourPatches ++ upstreamPatches;
    });

    tokenizer = prev.extensions.tokenizer.overrideAttrs (attrs: {
      patches = builtins.filter
        (patch:
          # The patch do not apply to PHP < 8.1
          patchName patch == "fix-tokenizer-php81.patch" -> lib.versionAtLeast prev.php.version "8.1"
        )
        (attrs.patches or []);
    });

    wddx =
      if lib.versionOlder prev.php.version "7.4" then
        prev.mkExtension {
          name = "wddx";

          buildInputs = [
            pkgs.libxml2
          ];

          internalDeps = [
            final.extensions.session
          ];

          configureFlags = [
            "--enable-wddx"
            "--with-libxml-dir=${pkgs.libxml2.dev}"
          ];
        }
      else
        throw "php.extensions.wddx requires PHP version < 7.4.";

    xdebug =
      # xdebug versions were determined using https://xdebug.org/docs/compat
      if lib.versionAtLeast prev.php.version "8.0" then
        prev.extensions.xdebug
      else if lib.versionAtLeast prev.php.version "7.2" then
        prev.extensions.xdebug.overrideAttrs (attrs: {
          name = "xdebug-3.1.6";
          version = "3.1.6";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/xdebug-3.1.6.tgz";
            sha256 = "1lnmrb5kgq8lbhjs48j3wwhqgk44pnqb1yjq4b5r6ysv9l5wlkjm";
          };
        })
      else if lib.versionAtLeast prev.php.version "7.1" then
        prev.extensions.xdebug.overrideAttrs (attrs: {
          name = "xdebug-2.9.8";
          version = "2.9.8";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/xdebug-2.9.8.tgz";
            sha256 = "12igfrdfisqfmfqpc321g93pm2w1y7h24bclmxjrjv6rb36bcmgm";
          };
        })
      else if lib.versionAtLeast prev.php.version "7.0" then
        prev.extensions.xdebug.overrideAttrs (attrs: {
            name = "xdebug-2.7.2";
            version = "2.7.2";
            src = pkgs.fetchurl {
              url = "http://pecl.php.net/get/xdebug-2.7.2.tgz";
              sha256 = "19m40n5h339yk0g458zpbsck1lslhnjsmhrp076kzhl5l4x2iwxh";
            };
          })
      else
        prev.extensions.xdebug.overrideAttrs (attrs: {
          name = "xdebug-2.5.5";
          version = "2.5.5";
          src = pkgs.fetchurl {
            url = "http://pecl.php.net/get/xdebug-2.5.5.tgz";
            sha256 = "197i1fcspbrdxki6rljvpjdxzhyaxl7nlihhiqcyfkjipkr8n43j";
          };
        });

    xml = prev.extensions.xml.overrideAttrs (attrs: {
      configureFlags =
        attrs.configureFlags or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Required to build on darwin.
          "--with-libxml-dir=${pkgs.libxml2.dev}"
        ];
    });

    xmlreader = prev.extensions.xmlreader.overrideAttrs (attrs: {
      configureFlags =
        attrs.configureFlags or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Required to build on darwin.
          "--with-libxml-dir=${pkgs.libxml2.dev}"
        ];
    });

    xmlrpc =
      if lib.versionOlder prev.php.version "8.0" then
        prev.mkExtension {
          name = "xmlrpc";
          buildInputs = [
            pkgs.libxml2
            pkgs.libiconv
          ];
          configureFlags = [
            "--with-xmlrpc"
          ] ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
            # Required to build on darwin.
            "--with-libxml-dir=${pkgs.libxml2.dev}"
          ];
        }
      else
        throw "php.extensions.xmlrpc is no longer available in PHP version >= 8.0.";

    xmlwriter = prev.extensions.xmlwriter.overrideAttrs (attrs: {
      configureFlags =
        attrs.configureFlags or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          # Required to build on darwin.
          "--with-libxml-dir=${pkgs.libxml2.dev}"
        ];
    });

    zip = prev.extensions.zip.overrideAttrs (attrs: {
      configureFlags =
        attrs.configureFlags or []
        ++ lib.optionals (lib.versionOlder prev.php.version "7.3") [
          "--with-libzip"
        ]
        ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
          "--with-zlib-dir=${pkgs.zlib.dev}"
        ];
    });

    zlib = prev.extensions.zlib.overrideAttrs (attrs: {
      patches =
        attrs.patches or []
        ++ lib.optionals (lib.versionAtLeast prev.php.version "7.1" && lib.versionOlder prev.php.version "7.4") [
          # Fix Darwin build
          # Introduced in https://github.com/NixOS/nixpkgs/commit/af064a0e12ad8e5a8a2e8d8ad25fc0baf3f8ef54
          # Derived from https://github.com/php/php-src/commit/f16b012116d6c015632741a3caada5b30ef8a699
          ./patches/zlib-darwin-tests.patch
        ];

        configureFlags =
          attrs.configureFlags or []
          ++ lib.optionals (lib.versionOlder prev.php.version "7.4") [
            "--with-zlib-dir=${pkgs.zlib.dev}"
          ];
    });
  };
}
