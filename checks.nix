{
  system,
  packages,
  pkgs,
}:

let
  phpPackages = builtins.filter (name: builtins.match "php([0-9]+|-master)" name != null) (builtins.attrNames packages);

  checks = {
    php = {
      description = "Build PHP";
      drv = { php, ... }: php;
    };

    imagick = {
      description = "Build Imagick extension";
      drv = { php, ... }: php.extensions.imagick;
    };

    redis = {
      description = "Build Redis extension";
      drv = { php, ... }: php.extensions.redis;
    };

    redis3 = {
      description = "Build Redis 3 extension";
      enabled = { php, lib, ... }: lib.versionOlder php.version "8";
      drv = { php, ... }: php.extensions.redis3;
    };

    mysql = {
      description = "Build MySQL extension";
      enabled = { php, lib, ... }: lib.versionOlder php.version "7";
      drv = { php, ... }: php.extensions.mysql;
    };

    xdebug = {
      description = "Build Xdebug extension";
      drv = { php, ... }: php.extensions.xdebug;
    };

    tidy = {
      description = "Build Tidy extension";
      drv = { php, ... }: php.extensions.tidy;
    };

    composer-phar = {
      description = "Check that composer PHAR works";
      drv =
        { pkgs, php, ... }:
        pkgs.runCommand
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
        { pkgs, php, ... }:
        pkgs.runCommand
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
        { pkgs, php, ... }:
        pkgs.runCommand
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
  };

  inherit (pkgs) lib;

  /* AttrSet<phpName, AttrSet<checkName, checkDrv>> */
  checksPerVersion =
    lib.listToAttrs (
      builtins.map
        (phpName:
          let
            php = packages.${phpName};
            phpVersion = lib.versions.majorMinor php.version;
            args = { inherit lib php pkgs system; };
            supportedChecks = lib.filterAttrs (_name: { enabled ? lib.const true, ... }: enabled args) checks;
          in
          {
            name = phpName;
            value =
              lib.mapAttrs
                (
                  _name:
                  {
                    description,
                    drv,
                    ...
                  }:

                  let
                    check = drv args;
                  in
                  check // {
                    passthru = check.passthru or { } // {
                      description = "PHP ${phpVersion} – ${description}";
                    };
                  }
                )
                supportedChecks;
          }
        )
        phpPackages
    );
in
lib.foldAttrs
  lib.mergeAttrs
  {}
  (
    lib.mapAttrsToList
    (
      phpName:

      lib.mapAttrs'
        (
          name:

          lib.nameValuePair "${phpName}-${name}"
        )
    )
    checksPerVersion
  )
