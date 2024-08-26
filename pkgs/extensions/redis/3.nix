{
  buildPecl,
  lib,
  php,
  fetchurl,
}:

buildPecl {
  version = "3.1.6";
  pname = "redis";

  src = fetchurl {
    url = "http://pecl.php.net/get/redis-3.1.6.tgz";
    hash = "sha256-siknTNwUwi78Qf76ANtNxbsyqZfWgRJ4ZioEOnaqJgA=";
  };

  internalDeps = [ php.extensions.session ];

  meta = {
    description = "PHP extension for interfacing with Redis";
    license = lib.licenses.php301;
    platforms = lib.platforms.linux;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = lib.teams.php.members;
  };
}
