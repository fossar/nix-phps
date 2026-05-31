{
  stdenv,
  buildPecl,
  lib,
  php,
  fetchurl,
}:

buildPecl {
  version = "5.3.7";
  pname = "redis";

  src = fetchurl {
    url = "http://pecl.php.net/get/redis-5.3.7.tgz";
    hash = "sha256-uVgWbM2k9AvRfGmY+eIjkCGuZERnzYrVwV3vQgqtZbA=";
  };

  internalDeps = [
    php.extensions.session
    php.extensions.json
  ];

  meta = {
    description = "PHP extension for interfacing with Redis";
    license = lib.licenses.php301;
    platforms = lib.platforms.unix;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = lib.teams.php.members;
  };
}
