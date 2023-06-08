{
  lib,
  php,
  runCommand,
}:

{
  php = {
    description = "Build PHP";
    drv = php;
  };

  imagick = {
    description = "Build Imagick extension";
    drv = php.extensions.imagick;
  };

  redis = {
    description = "Build Redis extension";
    drv = php.extensions.redis;
  };

  redis3 = {
    description = "Build Redis 3 extension";
    enabled = lib.versionOlder php.version "8";
    drv = php.extensions.redis3;
  };

  mysql = {
    description = "Build MySQL extension";
    enabled = lib.versionOlder php.version "7";
    drv = php.extensions.mysql;
  };

  xdebug = {
    description = "Build Xdebug extension";
    drv = php.extensions.xdebug;
  };

  tidy = {
    description = "Build Tidy extension";
    drv = php.extensions.tidy;
  };

  composer-phar = {
    description = "Check that composer PHAR works";
    drv =
      runCommand
        "composer-phar-check"
        {
          buildInputs = [
            php.packages.composer
          ];
        }
        ''
          composer --version
          touch "$out"
        '';
  };

  mysqli-socket-path = {
    description = "Validate php.extensions.mysqli default unix socket path";
    drv =
      runCommand
        "mysqli-socket-path-check"
        {
          buildInputs = [
            (php.withExtensions ({ all, ... }: [
              all.mysqli
            ]))
          ];
        }
        ''
          php -r "echo ini_get('mysqli.default_socket') . PHP_EOL;" | grep /run/mysqld/mysqld.sock
          touch "$out"
        '';
  };

  pdo_mysql-socket-path = {
    description = "Validate php.extensions.pdo_mysql default unix socket path";
    drv =
      runCommand
        "pdo_mysql-socket-path-check"
        {
          buildInputs = [
            (php.withExtensions ({ all, ... }: [
              all.pdo_mysql
            ]))
          ];
        }
        ''
          php -r "echo ini_get('pdo_mysql.default_socket') . PHP_EOL;" | grep /run/mysqld/mysqld.sock
          touch "$out"
        '';
  };
}
