nixpkgs:

# These are older versions of PHP removed from Nixpkgs.

final: prev:

let
  packageOverrides = import ./package-overrides.nix prev;

  libxml2_12 = prev.callPackage ./libxml2/2.12.nix { };

  inherit (prev) lib;

  inherit (import ./lib.nix { inherit lib; }) mergeEnv;

  inherit (prev.stdenv.cc) isClang;

  _mkArgs =
    args:

    let
      libxml2 = if lib.versionAtLeast args.version "8.1" then prev.libxml2 else libxml2_12;

      # Use a consistent libxml2 version.
      libxslt = prev.libxslt.override { inherit libxml2; };

      pcre2 = if lib.versionAtLeast args.version "7.3" then prev.pcre2 else prev.pcre;
    in
    {
      inherit packageOverrides libxml2 pcre2;

      phpAttrsOverrides =
        attrs:

        {
          patches =
            attrs.patches or [ ]
            ++ lib.optionals (lib.versions.majorMinor args.version == "5.6") [
              # Patch to make it build with autoconf >= 2.72
              # Source: https://aur.archlinux.org/packages/php56-ldap?all_deps=1#comment-954506
              ./patches/php56-autoconf.patch
            ]
            ++ lib.optionals (lib.versions.majorMinor args.version == "7.2") [
              # Building the bundled intl extension fails on Mac OS.
              # See https://bugs.php.net/bug.php?id=76826 for more information.
              (prev.pkgs.fetchurl {
                url = "https://bugs.php.net/patch-display.php?bug_id=76826&patch=bug76826.poc.0.patch&revision=1538723399&download=1";
                hash = "sha256-6JoyxVir3AG3VC6Q0uKrfb/ZFjs9/db+uZg3ssBdqzw=";
              })
            ]
            ++ lib.optionals (lib.versionOlder args.version "7.4") [
              # Handle macos versions that don't start with 10.* in libtool.
              # https://github.com/php/php-src/commit/d016434ad33284dfaceb8d233351d34356566d7d
              (prev.pkgs.fetchpatch {
                url = "https://github.com/php/php-src/commit/d016434ad33284dfaceb8d233351d34356566d7d.patch";
                hash = "sha256-VQfd1sKYX9kzulvnr5CJ0FNl/6Y4mObyzT3GBs4Mq10=";
                includes = [
                  "build/libtool.m4"
                ];
              })
            ];

          configureFlags =
            attrs.configureFlags
            ++ lib.optionals (lib.versionOlder args.version "7.4") [
              # phar extension’s build system expects hash or it will degrade.
              "--enable-hash"

              "--enable-libxml"
              "--with-libxml-dir=${libxml2.dev}"
            ]
            ++ lib.optionals (lib.versions.majorMinor args.version == "7.3") [
              # Force use of pkg-config.
              # https://github.com/php/php-src/blob/php-7.3.33/ext/pcre/config0.m4#L14
              "--with-pcre-regex=/usr"
            ]
            ++ lib.optionals (lib.versionOlder args.version "7.3") [
              # Only PCRE 1 supported and no pkg-config.
              "--with-pcre-regex=${prev.pcre.dev}"
              "PCRE_LIBDIR=${prev.pcre}"
            ];

          buildInputs =
            attrs.buildInputs
            ++ lib.optionals (lib.versionOlder args.version "7.1") [
              prev.libxcrypt
            ];

          preConfigure =
            lib.optionalString (lib.versionOlder args.version "7.4") ''
              # Workaround “configure: error: Your system does not support systemd.”
              # caused by PHP build system expecting PKG_CONFIG variable to contain
              # an absolute path on PHP ≤ 7.4.
              # Also patches acinclude.m4, which ends up being used by extensions.
              # https://github.com/NixOS/nixpkgs/pull/90249
              for i in $(find . -type f -name "*.m4"); do
                substituteInPlace $i \
                  --replace 'test -x "$PKG_CONFIG"' 'type -P "$PKG_CONFIG" >/dev/null'
              done
            ''
            + attrs.preConfigure;

          env = mergeEnv attrs {
            NIX_CFLAGS_COMPILE =
              # Downgrade the following errors to warnings.
              lib.optionals (lib.versionOlder args.version "8.2") [
                "-Wno-compare-distinct-pointer-types"
                "-Wno-implicit-const-int-float-conversion"
                "-Wno-deprecated-declarations"
                "-Wno-incompatible-${lib.optionalString isClang "function-"}pointer-types"
                "-Wno-incompatible-pointer-types-discards-qualifiers"
              ]
              ++ lib.optionals (lib.versionOlder args.version "8.0") [
                "-Wno-implicit-int"
                "-Wno-implicit-function-declaration"
              ]
              ++ lib.optionals (lib.versionAtLeast args.version "7.3" && lib.versionOlder args.version "7.4") [
                "-Wno-int-conversion"
              ];
          };
        };

      # For passing libxml2 and pcre2 to php-packages.nix.
      callPackage =
        cpFn: cpArgs:

        (prev.callPackage cpFn cpArgs).override (
          prevArgs:

          # Only pass these attributes if the package function actually expects them.
          lib.filterAttrs (key: _v: builtins.hasAttr key prevArgs) {
            inherit libxml2 libxslt pcre2;

            # For passing pcre2 to stuff called with callPackage in php-packages.nix.
            pkgs =
              prev
              // (lib.makeScope prev.newScope (self: {
                inherit libxml2 libxslt pcre2;
              }));
          }
        );
    }
    // args;

  generic = "${nixpkgs}/pkgs/development/interpreters/php/generic.nix";
  mkPhp = args: prev.callPackage generic (_mkArgs args);
in
{
  php56 = import ./php/5.6.nix { inherit prev mkPhp; };

  php70 = import ./php/7.0.nix { inherit prev mkPhp; };

  php71 = import ./php/7.1.nix { inherit prev mkPhp; };

  php72 = import ./php/7.2.nix { inherit prev mkPhp; };

  php73 = import ./php/7.3.nix { inherit prev mkPhp; };

  php74 = import ./php/7.4.nix { inherit prev mkPhp; };

  php80 = import ./php/8.0.nix { inherit prev mkPhp; };

  php81 = prev.php81.override {
    inherit packageOverrides;
  };

  php82 = prev.php82.override {
    inherit packageOverrides;
  };

  php83 = prev.php83.override {
    inherit packageOverrides;
  };

  php84 = prev.php84.override {
    inherit packageOverrides;
  };
}
