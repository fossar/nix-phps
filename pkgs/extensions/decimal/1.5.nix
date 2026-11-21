{
  buildPecl,
  lib,
  mpdecimal,
  php,
  stdenv,
}:

buildPecl (finalAttrs: {
  pname = "decimal";
  version = "1.5.0";

  hash = "sha256-it8w8hOLYwtCZoDYhaP5k5TD/pQLtj37K2lSESF80ok=";

  internalDeps = [
    php.extensions.json
  ];

  buildInputs = [
    mpdecimal
  ];

  configureFlags = [
    "--with-libmpdec-path=${mpdecimal}"
  ];

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString (lib.versionOlder php.version "7.4") "-Wno-incompatible-${lib.optionalString stdenv.cc.isClang "function-"}pointer-types";
  };

  # The source is a PECL tarball and PECL lacks releases that GitHub tags have (2.0.2)
  passthru.updateScript = null;

  meta = {
    description = "Arbitrary-precision decimal arithmetic for PHP";
    homepage = "https://php-decimal.github.io";
    changelog = "https://pecl.php.net/package-changelog.php?package=decimal&release=${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.php ];
  };
})
