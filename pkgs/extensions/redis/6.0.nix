{
  stdenv,
  buildPecl,
  lib,
  php,
  fetchurl,
}:

buildPecl {
  version = "6.0.2";
  pname = "redis";

  src = fetchurl {
    url = "http://pecl.php.net/get/redis-6.0.2.tgz";
    hash = "sha256-Aa7MsOFPiX/lbwUJvm5pkf8K1Fn5006V5FVtAmmbmgM=";
  };

  internalDeps = [
    php.extensions.session
    php.extensions.json
  ];

  env = lib.optionalAttrs (lib.versionOlder php.version "7.2" && stdenv.cc.isClang) {
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -Wno-int-conversion";
  };

  meta = {
    description = "PHP extension for interfacing with Redis";
    license = lib.licenses.php301;
    platforms = lib.platforms.unix;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = lib.teams.php.members;
  };
}
