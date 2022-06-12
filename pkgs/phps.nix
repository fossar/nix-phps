nixpkgs:

# These are older versions of PHP removed from Nixpkgs.

final:
prev:

let
  packageOverrides = import ./package-overrides.nix prev;

  _mkArgs =
    args:

    {
      inherit packageOverrides;

      # For passing pcre2 to generic.nix.
      pcre2 =
        if prev.lib.versionAtLeast args.version "7.3"
        then prev.pcre2
        else prev.pcre;

      phpAttrsOverrides =
        attrs:

        {
          patches =
            attrs.patches or []
            ++ prev.lib.optionals (prev.lib.versions.majorMinor args.version == "7.2") [
              # Building the bundled intl extension fails on Mac OS.
              # See https://bugs.php.net/bug.php?id=76826 for more information.
              (prev.pkgs.fetchpatch {
                url = "https://bugs.php.net/patch-display.php?bug_id=76826&patch=bug76826.poc.0.patch&revision=1538723399&download=1";
                sha256 = "aW+MW9Kb8N/yBO7MdqZMZzgMSF7b+IMLulJKgKPWrUA=";
              })
            ];

          configureFlags =
            attrs.configureFlags
            ++ prev.lib.optionals (prev.lib.versionOlder args.version "7.4") [
              # phar extension’s build system expects hash or it will degrade.
              "--enable-hash"

              "--enable-libxml"
              "--with-libxml-dir=${prev.libxml2.dev}"
            ];

          preConfigure =
            prev.lib.optionalString (prev.lib.versionOlder args.version "7.4") ''
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
        };

      # For passing pcre2 to php-packages.nix.
      callPackage =
        cpFn:
        cpArgs:

        prev.callPackage
          cpFn
          (
            cpArgs
            // {
              pcre2 =
                if prev.lib.versionAtLeast args.version "7.3"
                then prev.pcre2
                else prev.pcre;

              # For passing pcre2 to stuff called with callPackage in php-packages.nix.
              pkgs =
                prev
                // (
                  prev.lib.makeScope
                    prev.newScope
                    (self: {
                      pcre2 =
                        if prev.lib.versionAtLeast args.version "7.3"
                        then prev.pcre2
                        else prev.pcre;
                    })
                );
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

  php80 = prev.php80.override {
    inherit packageOverrides;
  };

  php81 = prev.php81.override {
    inherit packageOverrides;
  };
}
