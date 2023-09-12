{ prev, mkPhp, ... }:

let
  archives = [
    { version = "7.3.0"; rev = "php-7.3.0"; hash = "sha256-eiZ9rsmWmpl8XIAow1AilkZ0jg/MceLy27FX3c7ofGc="; }
    { version = "7.3.1"; rev = "php-7.3.1"; hash = "sha256-r+8rDNfyZBJ0oaCqvmfjDyM0lw18UwOC36nXnP50OI4="; }
    { version = "7.3.2"; rev = "php-7.3.2"; hash = "sha256-lG9Q2svS9h5kO7c3Ahy+ixgW54DuetPgzZmaGJKrCt0="; }
    { version = "7.3.3"; rev = "php-7.3.3"; hash = "sha256-YZaelDrf6nlwGjS45wHt0/lb6CnRZgGkqr6wX4MCPOY="; }
    { version = "7.3.4"; rev = "php-7.3.4"; hash = "sha256-Liw9ghLINknkQ7Ye//vQPfS57dD5x6Z5CB/kyy2hK3g="; }
    { version = "7.3.5"; rev = "php-7.3.5"; hash = "sha256-Q4C4DvmCZ8OCPDQW6wX3cpunoz3ms9FOyWATIV1iw14="; }
    { version = "7.3.6"; rev = "php-7.3.6"; hash = "sha256-HlrIcAFUg1wJEOOoFFF9qbh7tKgsxwEf6hqCCWtvb3c="; }
    { version = "7.3.7"; rev = "php-7.3.7"; hash = "sha256-w2CPpxFGQnJYVBGcz/5yL0L8fDHl5MANXLTLGg0Wvxg="; }
    { version = "7.3.8"; rev = "php-7.3.8"; hash = "sha256-1WbGMBddn6hKmNPJFw7AMwaeniDI0j3qSa4ql2tsdvU="; }
    { version = "7.3.9"; rev = "php-7.3.9"; hash = "sha256-o5yXCajJ636orEkz73p4uS9+VzWkBci45C7jlUHZY8Q="; }
    { version = "7.3.10"; rev = "php-7.3.10"; hash = "sha256-UG3YccD7jwD4cvU907HfpfI6nttN/FIeVmnHinjEVEg="; }
    { version = "7.3.11"; rev = "php-7.3.11"; hash = "sha256-ktH/SxPHCTY18ewzil5okcqZsQ5l+8rdUn5buE0Rtec="; }
    { version = "7.3.12"; rev = "php-7.3.12"; hash = "sha256-0xewKfmRQQV4zDi6S3bJ92TsKcZ+cSTh/sV7zrOtjDk="; }
    { version = "7.3.13"; rev = "php-7.3.13"; hash = "sha256-XHuJBigU88OVPRUY9j7UY/1FKSnjo3EQr0FwxdIyZ7w="; }
    { version = "7.3.14"; rev = "php-7.3.14"; hash = "sha256-ud/Lu8kpzmeZX5dt6GNsX0aARZPsrm4RBQkym53GwnI="; }
    { version = "7.3.15"; rev = "php-7.3.15"; hash = "sha256-jb4VB+oANfQhH6oNuA/pXznfDjnYQIIjgg/pEjSHBD0="; }
    { version = "7.3.16"; rev = "php-7.3.16"; hash = "sha256-uActUmooMYKWOwOWC3mCOS2qQ8sxEx7KTPC5lnZKBC4="; }
    { version = "7.3.17"; rev = "php-7.3.17"; hash = "sha256-2D6Q2QJMmZ8gmTNzLtTh0OcpWmfGareUkImOoKSilwk="; }
    { version = "7.3.18"; rev = "php-7.3.18"; hash = "sha256-dJ0h9l3rVxU7V1+EZwX121RzLGtnLoBhKync8aU76KQ="; }
    { version = "7.3.19"; rev = "php-7.3.19"; hash = "sha256-DZweMeKftG/2YLSAUdFp1QywKF5hHRZZFEnVeDINNKU="; }
    { version = "7.3.20"; rev = "php-7.3.20"; hash = "sha256-xu14lJEaz+B1OBwBsHdF2S6SWfrFEKhJ90Lttrlcid4="; }
    { version = "7.3.21"; rev = "php-7.3.21"; hash = "sha256-27DqOefks4FNbR3TrFmDrtbDjN9VRkZF2hGosTSp96c="; }
    { version = "7.3.22"; rev = "php-7.3.22"; hash = "sha256-x5C4FyUgsv93PWz4B3TqCmeKLxbo7msR1ogCCURIaJ4="; }
    { version = "7.3.23"; rev = "php-7.3.23"; hash = "sha256-/WZmrUYFUIBCxpZBUTeUddrqNsQ+A7EbHnnUrmsEwEw="; }
    { version = "7.3.24"; rev = "php-7.3.24"; hash = "sha256-VbevuyA3sPj+/EgahfjfT3oni0t/Dtn2dMUOw4nMpZg="; }
    { version = "7.3.25"; rev = "php-7.3.25"; hash = "sha256-aTFaTaqR47B8kO74b+IFyIEsSsXOEZyZU+zJ9C53Avs="; }
    { version = "7.3.26"; rev = "php-7.3.26"; hash = "sha256-Nx5afIFU/TxSsUuqzl99BMS7uOhB01bFSitqaI2znU4="; }
    { version = "7.3.27"; rev = "php-7.3.27"; hash = "sha256-nSAG9eg1rPXkCONNgFCkk18hIasYvaQndaJ+1Zva4AM="; }
    { version = "7.3.28"; rev = "php-7.3.28"; hash = "sha256-j2NuZEWUOIQ26gX/NMnrE15twRnBEwGZ6UiNV5VDmWQ="; }
    { version = "7.3.29"; rev = "php-7.3.29"; hash = "sha256-qDooeBQL2Gk18ARrv+kmcsiraI++TM+XBK3WuWBe5NA="; }
    { version = "7.3.30"; rev = "php-7.3.30"; hash = "sha256-zMUy5mB2Hfm1UJubkT0twEmwqZVBCP4hKu64vCVWtQI="; }
    { version = "7.3.31"; rev = "php-7.3.31"; hash = "sha256-aVH3hSRoT0ORhv4DmrFPskWc6o9HrIKaFZckooP38ys="; }
    { version = "7.3.32"; rev = "php-7.3.32"; hash = "sha256-fBWLMG5TQ08eCohkeqVhgUMIqv+HE+19I37Y8TmcIW8="; }
    { version = "7.3.33"; rev = "php-7.3.33"; hash = "sha256-9BJIfX2VNDfnl4oNe27Jm/SoXPM3gBRDioV3uJU1RRo="; }
  ];

  phps = builtins.foldl'
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
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
