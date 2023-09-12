{ prev, mkPhp, ... }:

let
  archives = [
    { version = "7.1.0"; rev = "php-7.1.0"; hash = "sha256-aLz9fe7Vs0dNgd7J900SIFgyfivtCsJbvJ7HCZUijmE="; }
    { version = "7.1.1"; rev = "php-7.1.1"; hash = "sha256-15HTnXtU7EJEGgWl8G1opJVkfYQyEOOuTyxq25nGdbw="; }
    { version = "7.1.2"; rev = "php-7.1.2"; hash = "sha256-4PIhTiNmQ07iMRVrpwz+/QxZeQ8FDYcno/HcKv+mcAQ="; }
    { version = "7.1.3"; rev = "php-7.1.3"; hash = "sha256-wUWSTZG3olPszDH40i8VthWJzSTXgQXlYkDBu2QTuU8="; }
    { version = "7.1.4"; rev = "php-7.1.4"; hash = "sha256-Ob9peDbidgs6ROoyLp5fH1sfB6vrARH2SV7/dTjiWAU="; }
    { version = "7.1.5"; rev = "php-7.1.5"; hash = "sha256-KOqkeE8b2LfccSBtyMQ3VRAZlDLcF69pBrFNFrMFhpc="; }
    { version = "7.1.6"; rev = "php-7.1.6"; hash = "sha256-bjV2yndnKhhGGksInFeQZH8bLBn4Lk9elMliYJqr/88="; }
    { version = "7.1.7"; rev = "php-7.1.7"; hash = "sha256-B5tnkph/ONxIX5IljAT54C3t1ZP50mDr5yU0P4EtH/g="; }
    { version = "7.1.8"; rev = "php-7.1.8"; hash = "sha256-cGSgCpRQVlGQiQx6S+BOZG4L5zsuD4xGrjRBnzQ8ovg="; }
    { version = "7.1.9"; rev = "php-7.1.9"; hash = "sha256-MU3MEN/dfERD7bT+HhM6RPKyqDUb6MnrarkiLUX9m64="; }
    { version = "7.1.10"; rev = "php-7.1.10"; hash = "sha256-DuUbmxrn7KPpVY93LOIMus0fdkIACbOvYwyHAn+aQa8="; }
    { version = "7.1.11"; rev = "php-7.1.11"; hash = "sha256-dkbX3nAfyWnjMF7usu3do9Rq9qiO4g70pHJwxEcihXM="; }
    { version = "7.1.12"; rev = "php-7.1.12"; hash = "sha256-+c4zYauZ3Ojz8vumY2laybGKNXm8gBTcKANo0Vd9h8Q="; }
    { version = "7.1.13"; rev = "php-7.1.13"; hash = "sha256-Nf2lHS1EYAlAGF/VgY0zannnerPJjivQdQkfL5HPmKE="; }
    { version = "7.1.14"; rev = "php-7.1.14"; hash = "sha256-Y7L9E57XZWdWsPopC8Qvj/+FRyPD0nEKcA5kY3DFgfQ="; }
    { version = "7.1.15"; rev = "php-7.1.15"; hash = "sha256-4RelRzjpSF3l/HVnPTnb6Tfdh/D5zJ4oGWDvm5Ya3L0="; }
    { version = "7.1.16"; rev = "php-7.1.16"; hash = "sha256-NI4q+cfA8yelepcmdAeHd9/eGJ4lmKy8uGGLlkWw5+U="; }
    { version = "7.1.17"; rev = "php-7.1.17"; hash = "sha256-4STjrFUsUPOJDtmB0Hsu5HPKyWGIXnUYbe0Lu1t4288="; }
    { version = "7.1.18"; rev = "php-7.1.18"; hash = "sha256-WA43VRXt6DGm2C4TwOwl3QiyJcbYffwk181fO9VCv44="; }
    { version = "7.1.19"; rev = "php-7.1.19"; hash = "sha256-E8Q+e+MECtU/GSsHcMftmeWz40jfxmdGZhedVX/XcPM="; }
    { version = "7.1.20"; rev = "php-7.1.20"; hash = "sha256-OhtHbIj7gSVOpXLokaHWUFOrVAaDSOAMdei1T65pHUU="; }
    { version = "7.1.21"; rev = "php-7.1.21"; hash = "sha256-wkCcV0veI3Y7SKlrk5IvUwFW3wRFhf9gEIvOeyexlYA="; }
    { version = "7.1.22"; rev = "php-7.1.22"; hash = "sha256-yOkfGciqgQrpXyKP8xzw5IBcuJ9MEIcO4SyFSRsm52M="; }
    { version = "7.1.23"; rev = "php-7.1.23"; hash = "sha256-LXmqhtjw+qdgpxKh175QtXg4qXcMHf80Agh2YwwuzEs="; }
    { version = "7.1.24"; rev = "php-7.1.24"; hash = "sha256-Zt4k5zx/YAbwkMGxh9ayGMj6alE6zKT/XBS2lac5Hgs="; }
    { version = "7.1.25"; rev = "php-7.1.25"; hash = "sha256-ACzciArHz67eLDiSBNNmEIhH2w86xy7fG6lcBXf5qqw="; }
    { version = "7.1.26"; rev = "php-7.1.26"; hash = "sha256-WzUcqGvH5GAHeKrx1hq55OOIZO+oarTMTVsC6n9UKuY="; }
    { version = "7.1.27"; rev = "php-7.1.27"; hash = "sha256-2tfs0wlBkRUo5HHFVaAZEaaKqSGWlr/B4AX4tmn07Es="; }
    { version = "7.1.28"; rev = "php-7.1.28"; hash = "sha256-c56HM/4fxeaeYibabbp6MbrP0uOHGtLJenkmOPIsVMk="; }
    { version = "7.1.29"; rev = "php-7.1.29"; hash = "sha256-hSjRfv6CZi3HQNlt2zIhf04WGll9cJ8ZVxsMgvu4gzU="; }
    { version = "7.1.30"; rev = "php-7.1.30"; hash = "sha256-ZkhQd0/KGdJxC5qjXprpEhS6u96c2NJ/00ecyXFx7LM="; }
    { version = "7.1.31"; rev = "php-7.1.31"; hash = "sha256-dnVzwrcy54zGR2Auxh/JSJQalBpAcdtZtSLPXgdoJd0="; }
    { version = "7.1.32"; rev = "php-7.1.32"; hash = "sha256-18ehrd3HWsF/YzSelm2yWTC2s85zZkA0m+qeEJCcq3o="; }
    { version = "7.1.33"; rev = "php-7.1.33"; hash = "sha256-laXl8uK3mzdrc3qC2WgskYkeYCifokGDRjoqyhWPT0s="; }
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
