{
  nixpkgs,
  php-src,
}:

# These are older versions of PHP removed from Nixpkgs.

final:
prev:

let
  packageOverrides = import ./package-overrides.nix prev;

  /* Composes package overrides (i.e. overlays that only take prev). */
  composeOverrides = a: b: prev.lib.composeExtensions (_: a) (_: b) { };

  _mkArgs =
    {
      # Keep default flags in sync with generic.nix
      pearSupport ? true,
      ...
    }@args:

    args // {
      inherit packageOverrides;

      # For passing pcre2 to generic.nix.
      pcre2 =
        if prev.lib.versionAtLeast args.version "7.3"
        then prev.pcre2
        else prev.pcre;

      # Overrides attributes passed to the stdenv.mkDerivation for the unwrapped PHP
      # in <nixpkgs/pkgs/development/interpreters/php/generic.nix>.
      # This will essentially end up creating a derivation equivalent to the following:
      # stdenv.mkDerivation (versionSpecificOverrides (commonOverrides { /* stuff passed to mkDerivation in generic.nix */ }))
      phpAttrsOverrides =
        let
          commonOverrides =
            attrs:

            {
              patches =
                let
                  upstreamPatches =
                    attrs.patches or [ ];

                  ourPatches =
                    prev.lib.optionals (prev.lib.versions.majorMinor args.version == "7.2") [
                      # Building the bundled intl extension fails on Mac OS.
                      # See https://bugs.php.net/bug.php?id=76826 for more information.
                      (prev.pkgs.fetchpatch {
                        url = "https://bugs.php.net/patch-display.php?bug_id=76826&patch=bug76826.poc.0.patch&revision=1538723399&download=1";
                        sha256 = "aW+MW9Kb8N/yBO7MdqZMZzgMSF7b+IMLulJKgKPWrUA=";
                      })
                    ];
                in
                ourPatches ++ upstreamPatches;

              configureFlags =
                attrs.configureFlags
                ++ prev.lib.optionals (prev.lib.versionOlder args.version "7.4") [
                  # phar extension’s build system expects hash or it will degrade.
                  "--enable-hash"
                ] ++ prev.lib.optionals (pearSupport && (prev.lib.versionOlder args.version "7.4" || prev.lib.hasPrefix "7.4.0.pre" args.version)) [
                  # The flag was renamed in 7.4.0RC1 but `generic.nix` applies it for PHP < 7.4.
                  # https://github.com/php/php-src/commit/9f0c9b7ad6316b6185a2fc2997bf241785c30120
                  "--enable-libxml"
                ];

              preConfigure =
                attrs.preConfigure
                + prev.lib.optionalString (prev.lib.versionOlder args.version "7.4" || prev.lib.hasPrefix "7.4.0.pre" args.version) ''
                  # Workaround “configure: error: Your system does not support systemd.”
                  # caused by PHP build system expecting PKG_CONFIG variable to contain
                  # an absolute path on PHP ≤ 7.4.
                  # `generic.nix` works arounds this by patching the checks but only on PHP < 7.4
                  # but this is also issue on PHP 7.4 development versions.
                  # https://github.com/NixOS/nixpkgs/pull/90249
                  for i in $(find . -type f -name "*.m4"); do
                    substituteInPlace $i \
                      --replace 'test -x "$PKG_CONFIG"' 'type -P "$PKG_CONFIG" >/dev/null'
                  done
                ''
                + prev.lib.optionalString (prev.lib.hasPrefix "7.4.0.pre" args.version) ''
                  # Workaround IFS='.' misinteracting with unquoted Nix store path
                  # containing a period.
                  # https://bugs.php.net/bug.php?id=78788
                  # Introduced in 7.4.0RC1, fixed in 7.4.0RC6.
                  # https://github.com/php/php-src/commit/afd52f9d9986d92dd0c63832a07ab1a16bf11d53
                  # https://github.com/php/php-src/pull/4891
                  substituteInPlace configure.ac --replace 'echo AC_PACKAGE_VERSION | $SED' 'echo AC_PACKAGE_VERSION | "''${SED}"'
                '';
            };

          versionSpecificOverrides = args.phpAttrsOverrides or (attrs: { });
        in
        composeOverrides commonOverrides versionSpecificOverrides;

      # For passing pcre2 to php-packages.nix.
      callPackage =
        cpFn:
        cpArgs:

        prev.callPackage cpFn (cpArgs // {
          pcre2 =
            if prev.lib.versionAtLeast args.version "7.3"
            then prev.pcre2
            else prev.pcre;

          # For passing pcre2 to stuff called with callPackage in php-packages.nix.
          pkgs =
            prev // prev.lib.makeScope prev.newScope (self: {
              pcre2 =
                if prev.lib.versionAtLeast args.version "7.3"
                then prev.pcre2
                else prev.pcre;
            });
        });
    };

  generic = "${nixpkgs}/pkgs/development/interpreters/php/generic.nix";

  base56 =
    prev.callPackage generic (_mkArgs {
      version = "5.6.40";
      sha256 = "/9Al00YjVTqy9/2Psh0Mnm+fow3FZcoDode3YwI/ugA=";
    });

  base70 =
    prev.callPackage generic (_mkArgs {
      version = "7.0.33";
      sha256 = "STPqdCmKG6BGsCRv43cUFchN+4eDliAbVstTM6vobwc=";
    });

  base71 =
    prev.callPackage generic (_mkArgs {
      version = "7.1.33";
      sha256 = "laXl8uK3mzdrc3qC2WgskYkeYCifokGDRjoqyhWPT0s=";
    });

  base72 =
    prev.callPackage generic (_mkArgs {
      version = "7.2.34";
      sha256 = "DlgW1miiuxSspozvjEMEML2Gw8UjP2xCfRpUqsEnq88=";
    });

  base73 =
    prev.callPackage generic (_mkArgs {
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
    });

  base-master =
    prev.callPackage generic (_mkArgs {
      version =
        let
          configureFile = "${php-src}/configure.ac";

          extractVersionFromConfigureAc =
            configureText:

            let
              match = builtins.match ".*AC_INIT\\(\\[PHP],\\[([^]-]+)(-dev)?].*" configureText;
            in
            if match != null
            then builtins.head match
            else null;

          extractVersionFromConfigureAcPre74 =
            configureText:

            let
              match = builtins.match ".*PHP_MAJOR_VERSION=([0-9]+)\nPHP_MINOR_VERSION=([0-9]+)\nPHP_RELEASE_VERSION=([0-9]+)\n.*" configureText;
            in
            if match != null
            then prev.lib.concatMapStringsSep "." builtins.toString match
            else null;

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
        "${version}.pre+date=${php-src.lastModifiedDate}";
      sha256 = null;

      phpAttrsOverrides = attrs: {
        src = php-src;
        configureFlags = attrs.configureFlags ++ [
          # install-pear-nozlib.phar (normally shipped in tarball) would need to be downloaded.
          "--without-pear"
        ];
      };
    });
in
{
  php56 =
    base56.withExtensions
      (
        { all, ... }:

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
          sqlite3
          tokenizer
          xmlreader
          xmlwriter
          zip
          zlib
        ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
          imap
        ])
      );

  php70 =
    base70.withExtensions
      (
        { all, ... }:

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
          sqlite3
          tokenizer
          xmlreader
          xmlwriter
          zip
          zlib
        ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
          imap
        ])
      );

  php71 =
    base71.withExtensions
      (
        { all, ... }:

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
          sqlite3
          tokenizer
          xmlreader
          xmlwriter
          zip
          zlib
        ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
          imap
        ])
      );

  php72 =
    base72.withExtensions
      (
        { all, ... }:

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
        ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
          imap
        ])
      );

  php73 =
    base73.withExtensions
      (
        { all, ... }:

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
        ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
          imap
        ])
      );

  php74 =
    prev.php74.override {
      inherit packageOverrides;
    };

  php80 =
    prev.php80.override {
      inherit packageOverrides;
    };

  php81 =
    prev.php81.override {
      inherit packageOverrides;
    };

  php-master =
    base-master.withExtensions
      (
        { all, ... }:

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
        ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
          imap
        ])
      );
}
