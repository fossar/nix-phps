{ prev, mkPhp, ... }:

let
  archives = [
    { version = "7.4.0"; rev = "php-7.4.0"; hash = "sha256-vyBr6Wo55kMYABPfOd3NBJOWZpKiQixLfTNVtqFaAcA="; }
    { version = "7.4.1"; rev = "php-7.4.1"; hash = "sha256-axyg8Lg6ohA/HkVHOWZeGygCuQsxN/x5zKqMJCrkjk4="; }
    { version = "7.4.2"; rev = "php-7.4.2"; hash = "sha256-ApCZdL6ccIFO1WUqa9rpx0Ig1BweXtWtkh4V0Cj46BY="; }
    { version = "7.4.3"; rev = "php-7.4.3"; hash = "sha256-wVF7pJV4+y3MZMc6Ptx21PxQfEp6xjmYFYTMfTtMbRQ="; }
    { version = "7.4.4"; rev = "php-7.4.4"; hash = "sha256-MI6PQYLsiidnsLG44efGn7FJs3z7mO5KN0deCC+pgp8="; }
    { version = "7.4.5"; rev = "php-7.4.5"; hash = "sha256-OdqlM9W2PDOU2nEdwShn3XbC7DHJQLu6FvFOV33xPW8="; }
    { version = "7.4.6"; rev = "php-7.4.6"; hash = "sha256-pu2UdWldIFYyKj8sAP7mGhIqf84Tig4laUMgxd0dI0g="; }
    { version = "7.4.7"; rev = "php-7.4.7"; hash = "sha256-gA4NAfNZyOxBVAklwNSiTDTV8h72rd1tgv9KUr4j2Ho="; }
    { version = "7.4.8"; rev = "php-7.4.8"; hash = "sha256-akjTpgXAA7CImEzrU75d8eaYuLNd2srdEv5Q9JwOgGI="; }
    { version = "7.4.9"; rev = "php-7.4.9"; hash = "sha256-LicJWKQhZIDaeIZ0NDjMyStqzzLqlv79qI0H4KUJXes="; }
    { version = "7.4.10"; rev = "php-7.4.10"; hash = "sha256-6Qv8ntmNJOU7Uf/U62Ns9c2dce18b45LbpmB6YghdOc="; }
    { version = "7.4.11"; rev = "php-7.4.11"; hash = "sha256-VAjyVSQ70ikvP7wvr8J6LsCD/NhSkCco8rqaPqYWuMU="; }
    { version = "7.4.12"; rev = "php-7.4.12"; hash = "sha256-bm9zzCOe38RitWpFckAZaR+FtXt0kuHrW0tg9/qhmWc="; }
    { version = "7.4.13"; rev = "php-7.4.13"; hash = "sha256-FaM5hX4RyS60f93NDf6KqpUam+fFercjDM1JdGWjH9o="; }
    { version = "7.4.14"; rev = "php-7.4.14"; hash = "sha256-aInKBgWt7jqnB3UIzXn87x29iEYc3yXnwahpl7jQofY="; }
    { version = "7.4.15"; rev = "php-7.4.15"; hash = "sha256-G9e+ApNEbD08vjyfrmBFEZrweY+whp22GTJ5bcI6d1c="; }
    { version = "7.4.16"; rev = "php-7.4.16"; hash = "sha256-hXEPAHz9D66U4ToCo6A29Oge9DaTJgyuii4cqTZZzj4="; }
    { version = "7.4.17"; rev = "php-7.4.17"; hash = ""; }
    { version = "7.4.18"; rev = "php-7.4.18"; hash = "sha256-LkVZMunG9YibHch582/dV0Tq8f9XKxt3iVjLuPXBhC8="; }
    { version = "7.4.19"; rev = "php-7.4.19"; hash = "sha256-JdCbgUWyhNhwQxwbQKunlE5L8YNieFOPjil4Dn+F3eo="; }
    { version = "7.4.20"; rev = "php-7.4.20"; hash = "sha256-CtprxjXlMPp6TrVeY53AcAdxCOXJiF91C0cAf9JntjQ="; }
    { version = "7.4.21"; rev = "php-7.4.21"; hash = "sha256-NuxhAudX4sK3dCBXpwC7/3fHb6DMvpyGA5jD0k4ygio="; }
    { version = "7.4.22"; rev = "php-7.4.22"; hash = "sha256-UCK7ymYbwatd+u5yhzvNDwmA2d00+YCmggKUlvUcquE="; }
    { version = "7.4.23"; rev = "php-7.4.23"; hash = "sha256-0eCU/m5Pgy4KZL6caUZLpdWT+yFvkU76i7sITgp6Vyc="; }
    { version = "7.4.24"; rev = "php-7.4.24"; hash = "sha256-9Q4yt4iGQ0kEHxnjHcxlsfzGW8GRIpGPYHUmQy7fLzI="; }
    { version = "7.4.25"; rev = "php-7.4.25"; hash = "sha256-J5klcMrz4uUyOrezeFPETBUpsdMeqU2Xdu+pHVp4ExM="; }
    { version = "7.4.26"; rev = "php-7.4.26"; hash = "sha256-1ouIqPikN2SK/8x3k+XgYvoOxRcff9CvOFsSx4scAE0="; }
    { version = "7.4.27"; rev = "php-7.4.27"; hash = "sha256-GEqu8xP78oyZh/aqB7ZVzRsOrp5+FwYXdaPn2IAYVWM="; }
    { version = "7.4.28"; rev = "php-7.4.28"; hash = "sha256-IIUIaoY0RLDjlUfeGklp/RxAoMGI61j6spOLZJsMS1g="; }
    { version = "7.4.29"; rev = "php-7.4.29"; hash = "sha256-fd5YoCsiXCUTDG4q4su6clS7A0D3/hcpFHgXbYZvlII="; }
    { version = "7.4.30"; rev = "php-7.4.30"; hash = "sha256-tgG7EuU3IEabYOqBZ3bKwcBpawmIihGtI3my7ug1OG4="; }
    { version = "7.4.31"; rev = "php-7.4.31"; hash = ""; }
    { version = "7.4.32"; rev = "php-7.4.32"; hash = "sha256-m0w8If+7TzXXuGXb+IU4u6F0IzUkiuHMKvwwPUVuOqY="; }
    { version = "7.4.33"; rev = "php-7.4.33"; hash = "sha256-ToEXRY/lpHW/IDEocmtxvLumHEKtRj3/re5WZ6GYqYo="; }
  ];
in
builtins.foldl'
  (acc: item: acc // {
    "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = (mkPhp { version = item.version; hash = item.hash; }).withExtensions
      (
        { all, ... }: with all; [
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
          sysvsem
          sqlite3
          tokenizer
          xmlreader
          xmlwriter
          zip
          zlib
        ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
          imap
        ]
      );
  })
  { }
  (
    archives ++ [
      (
        let last = (prev.lib.last archives); in {
          version = prev.lib.versions.majorMinor last.version;
          rev = last.rev;
          hash = last.hash;
        }
      )
    ]
  )
