{
  buildPecl,
  lib,
  php,
  fetchurl,
}:

buildPecl {
  version = "4.3.0";
  pname = "redis";

  src = fetchurl {
    url = "http://pecl.php.net/get/redis-4.3.0.tgz";
    hash = "sha256-wPBM7DSZYKhCtgkg+4pDNlbi5JTq7W5mM5fWcQKlG6I=";
  };

  internalDeps = [ php.extensions.session ];

  meta = {
    description = "PHP extension for interfacing with Redis";
    license = lib.licenses.php301;
    platforms = lib.platforms.unix;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = lib.teams.php.members;
  };
}
